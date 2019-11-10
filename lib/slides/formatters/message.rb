module Slides
  module Formatters
    class Message < Formatter
      BOLD_PREFIX = '\e[1m'.freeze

      private

      def formatted
        apply_bold(raw)
      end

      def apply_bold(string)
        string.gsub(/'\*{2}(\w*\s?)*\*{2}'/) do |match|
          words = match.gsub(/'\*{2}|\*{2}'/, '').split(' ')

          words.each_with_object('')
            .with_index do |(word, return_string), index|
            return_string << BOLD_PREFIX
            return_string << word
            return_string << ' ' unless index == words.size - 1
          end
        end
      end
    end
  end
end
