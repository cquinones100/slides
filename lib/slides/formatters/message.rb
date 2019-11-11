module Slides
  module Formatters
    class Message < Formatter
      FORMAT_PREFIX = "\e[".freeze
      FORMAT_POSTFIX = 'm'.freeze
      FORMATS = { 'bold' => '1', 'underline' => '4' }.freeze

      private

      def formatted
        apply_formatting(raw)
      end

      # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      def apply_formatting(string)
        string.gsub(formats_text_regex) do |match|
          matched_formats = match.match(formats_start_regex)[0].split(',')

          format_values = matched_formats
            .each_with_object('')
            .with_index do |(format, format_value_strings), index|

            format_value_strings << FORMATS[format]
            format_value_strings << ';' unless index == matched_formats.size - 1
          end

          match_text = match.gsub(formats_regex, '').gsub(formats_regex, '')
          matched_words = match_text.split(' ')

          matched_words.each_with_index do |word, index|
            word_regex = if index == 0
                           /(?<=\s)?#{word}(?=\s)/
                         elsif index == matched_words.size - 1
                           /(?<=\s)#{word}(?=\s)?/
                         else
                           /(?<=\s)#{word}(?=\s)/
                         end

            match_text.gsub!(word_regex) do |matched_word|
              FORMAT_PREFIX + format_values + FORMAT_POSTFIX + matched_word
            end
          end

          match_text.strip + "\e[0m"
        end
      end
      # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

      def formats_regex
        /'(((#{formats.join('|')}),*)*)'/
      end

      def formats_start_regex
        /(?<=\A')(((#{formats.join('|')}),*)*)/
      end

      def formats_text_regex
        /#{formats_regex}[\w\W]*#{formats_regex}/
      end

      def formats
        FORMATS.keys
      end
    end
  end
end
