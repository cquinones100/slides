module Slides
  module Formatters
    class Character < String
      def initialize(character, characters, index)
        @characters = characters
        @index = index

        self << character
      end

      def whitespace?
        !(self =~ /\s/).nil?
      end

      def last?
        index == characters.size - 1
      end

      def newline?
        self == "\n"
      end

      private

      attr_reader :characters, :index
    end
  end
end
