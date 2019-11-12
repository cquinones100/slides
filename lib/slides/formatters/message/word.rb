module Slides
  module Formatters
    class Word < String
      def tag?
        formats.include? gsub(tag_regex, '')
      end

      def newline?
        self == "\n"
      end

      def to_code
        FormattedString::FORMATS[gsub(tag_regex, '')]
      end

      def stripped
        gsub(tag_regex, '')
      end

      private

      def formats
        @formats = FormattedString::FORMATS.keys
      end

      def tag_regex
        FormattedString::TAG_REGEX
      end
    end
  end
end
