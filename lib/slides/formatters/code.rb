require 'coderay'

module Slides
  module Formatters
    class Code < Formatter
      def initialize(language = :ruby, &block)
        @language = language

        super(&block)
      end

      private

      attr_reader :langauge, :block

      def highlighted
        CodeRay.scan(raw, :ruby).term.chomp
      end

      alias formatted highlighted
    end
  end
end
