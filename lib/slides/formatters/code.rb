require 'coderay'

module Slides
  module Formatters
    class Code < Formatter
      private

      attr_reader :langauge, :block

      def highlighted
        CodeRay.scan(raw, :ruby).term.chomp
      end

      alias formatted highlighted
    end
  end
end
