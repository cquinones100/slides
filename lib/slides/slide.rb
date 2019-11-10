module Slides
  class Slide
    attr_writer :index

    def initialize(&block)
      @block = block
      @texts = []
      @base = block.binding.receiver
      @index = nil
    end

    def print
      instance_eval(&block)

      clear

      STDOUT.puts("Slide #{index} of #{base.slides.size}")

      STDOUT.puts(with_vertical_padding { texts.join("\n\n") })
    end

    private

    attr_reader :block, :texts, :base, :index

    def clear
      system 'clear'
    end

    def message(&block)
      texts << block_source(block)
    end

    def code(&block)
      texts << Formatters::Code.new(&block)
    end

    def with_vertical_padding
      halved_height = window_height > 2 ? window_height / 2 : 0

      padding_string = ''

      halved_height.times { padding_string << "\n" }

      padding_string + yield + padding_string
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
