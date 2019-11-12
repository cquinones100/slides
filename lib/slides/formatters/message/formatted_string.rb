module Slides
  module Formatters
    class FormattedString < String
      TAG_REGEX = /(\A\s*')|('(\s*))/
      OPEN_CODE = "\e[".freeze
      CLOSE_CODE = "\e[0m".freeze
      FORMATS = {
        'bold' => '1',
        'underline' => '4',
        'red' => '31',
        'green' => '32',
        'yellow' => '33',
        'blue' => '34'
      }.freeze

      def initialize(raw)
        @raw = raw
        split_raw = raw.split('')

        @characters = split_raw.map.with_index do |character, index|
          Character.new(character, split_raw, index)
        end

        @tags = TagCollection.new
        @word = Word.new

        apply_formatting

        strip!
      end

      private

      attr_accessor :word
      attr_reader :raw, :characters, :tags

      def apply_formatting
        characters.each do |character|
          word << character

          if character.whitespace?
            process_word

            self.word = Word.new
          end

          process_word if character.last?
        end
      end

      def process_word
        if word.tag?
          tags.add word

          close_tag if tags.closed?

          return
        end

        return if word.empty?

        self << tags.code + word
      end

      def close_tag
        padding = ''

        gsub!(/\s\z/) do |match|
          padding = match

          ''
        end

        self << tags.close_code
        self << padding
        tags.reset!
      end
    end
  end
end
