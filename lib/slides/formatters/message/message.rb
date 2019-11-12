module Slides
  module Formatters
    class Message < Formatter
      private

      def formatted
        return @formatted unless @formatted.nil?

        @raw = if raw =~ raw_regex
                 raw.gsub(raw_regex, '')
               else
                 base.instance_eval(&block)
               end

        @formatted ||= FormattedString.new(raw)
      end

      def raw_regex
        /\A"|"\z/
      end
    end
  end
end
