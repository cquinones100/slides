require 'coderay'

module Slides
  module Formatters
    class Code < Formatter
      private

      attr_reader :block

      def formatted
        CodeRay.scan(raw, :ruby).term.chomp
      end
    end
  end
end
