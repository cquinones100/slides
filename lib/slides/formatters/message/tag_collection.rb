module Slides
  module Formatters
    class TagCollection
      attr_reader :opened, :closed

      def initialize
        @opened = []
        @closed = []
      end

      def reset!
        @opened = []
        @closed = []
      end

      def close_code
        FormattedString::CLOSE_CODE
      end

      def closed?
        !closed.empty? && opened.empty?
      end

      def add(word)
        if opened.last == word.stripped
          closed << opened.pop
        else
          opened << word.stripped
        end
      end

      def code
        opened.each_with_object('').with_index do |(tag, code_string), index|
          code_string << FormattedString::OPEN_CODE if index.zero?
          code_string << tag.to_code
          code_string << ';' if index != opened.size - 1
          code_string << 'm' if index == opened.size - 1
        end
      end
    end
  end
end
