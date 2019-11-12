module Slides
  module Formatters
    class FormattedString < String
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

      class Tags
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

      class Characters < Array
        def initialize(string)
          characters = string.split('')

          characters.each_with_index do |character, index|
            self << Character.new(character, characters, index)
          end
        end
      end

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

      TAG_REGEX = /(\A\s*')|('(\s*))/
      OPEN_CODE = "\e[".freeze
      CLOSE_CODE = "\e[0m".freeze
      FORMATS = {
        'bold' => '1',
        'underline' => '4',
        'red' => '31',
        'green' => '32',
        'yellow' => '33',
        'blue' => '34'
      }.freeze

      def initialize(raw)
        @raw = raw
        @characters = Characters.new(raw)
        @tags = Tags.new
        @word = Word.new

        apply_formatting

        strip!
      end

      private

      attr_accessor :word
      attr_reader :raw, :characters, :tags

      def apply_formatting
        characters.each do |character|
          word << character

          if character.whitespace?
            process_word

            self.word = Word.new
          end

          process_word if character.last?
        end
      end

      def process_word
        if word.tag?
          tags.add word

          if tags.closed?
            padding = ''

            gsub!(/\s\z/) do |match|
              padding = match

              ''
            end

            self << tags.close_code
            self << padding
            tags.reset!
          end

          return
        end

        return if word.empty?

        self << tags.code + word
      end
    end
  end
end
