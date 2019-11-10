module Slides
  class Slide
    attr_writer :index

    def initialize(&block)
      @block = block
      @texts = []
      @base = block.binding.receiver
      @index = nil
      @headers = []
    end

    def print
      instance_eval(&block)

      clear

      slide_number

      STDOUT.puts(headers.join("\n"))

      STDOUT.puts with_vertical_padding(with_horizontal_padding)

      STDIN.gets

      clear
    end

    private

    attr_reader :block, :texts, :base, :index, :headers

    def raw_lines
      @raw_lines ||= texts.each_with_object([]) do |text, array|
        raw_text = text.respond_to?(:raw) ? text.raw : text

        raw_text.split("\n").each { |line| array << line }
      end
    end

    def lines
      @lines ||= texts.each_with_object([]) do |text, array|
        text.split("\n").each { |line| array << line }
        array << "\n"
      end
    end

    def text_width
      raw_lines.sort_by(&:size)[-1].size
    end

    def text_height
      lines.size
    end

    def clear
      system 'clear'
    end

    def slide_number
      headers << "Slide #{index} of #{base.slides.size}"
    end

    def message(&block)
      texts << Formatters::Message.new(&block)
    end

    def code(&block)
      add_text Formatters::Code.new(&block)
    end

    def add_text(text)
      texts << text
    end

    def with_horizontal_padding
      return @with_horizontal_padding unless @with_horizontal_padding.nil?

      halved_width = window_width > 2 ? (window_width - text_width) / 2 : 0

      left_padding = ''

      halved_width.times { left_padding << ' ' }

      @with_horizontal_padding = lines.map { |string| left_padding + string }
        .join("\n")
    end

    def with_vertical_padding(string)
      halved_height = window_height > 2 ? (window_height - text_height) / 2 : 0

      padding_string_top = ''
      padding_string_bottom = ''

      (halved_height - headers.size - 1).times { padding_string_top << "\n" }
      halved_height.times { padding_string_bottom << "\n" }

      padding_string_top + string + padding_string_bottom
    end

    def window_height
      base.window_height
    end

    def window_width
      base.window_width
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
