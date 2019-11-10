require 'coderay'

module Slides
  module Formatters
    class Code < String
      def initialize(language = :ruby, &block)
        @language = language
        @block = block

        self << highlighted.chomp
      end

      private

      attr_reader :langauge, :block

      def highlighted
        CodeRay.scan(block_source(block), :ruby).term
      end

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
