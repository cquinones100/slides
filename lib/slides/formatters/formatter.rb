module Slides
  module Formatters
    class Formatter < String
      def initialize(base, &block)
        @base = base
        @block = block

        self << formatted
      end

      def raw
        @raw ||= block_source(block)
      end

      def formatted
        raise 'This method must be implemented by child formatter'
      end

      private

      attr_reader :base, :block

      def block_source(block)
        require 'pry'

        file, line = block.source_location

        source_text = Pry::Code.from_file(file).expression_at(line)

        string = source_text.scan(/do([.\S\s]*)end/).flatten.first

        leading_white_space = string.scan(/\A\s*/).first.delete("\n")

        string.strip.split("\n").map do |string_line|
          string_line.sub(leading_white_space, '')
        end.join("\n")
      end
    end
  end
end
