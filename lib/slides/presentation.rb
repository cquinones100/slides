require 'set'
require 'io/console'

module Slides
  class Presentation
    ERROR_MESSAGE = 'There were errors with defined presentations'.freeze
    NO_NAME_ERROR_MESSAGE = 'Error: no presentation name specified'.freeze
    PRESENTATION_NOT_FOUND_ERROR_MESSAGE = 'Error: Presentation not found'.freeze

    class << self
      def run(name = nil, slide_number = 0)
        return print(NO_NAME_ERROR_MESSAGE) if name.nil?
        return error unless errors.empty?

        found_presentation = presentations.find do |presentation|
          presentation.name.to_s == name.to_s
        end

        return presentation_not_found_error(name) if found_presentation.nil?

        found_presentation.run(slide_number.to_i)
      end

      def errors
        @errors ||= {}
      end

      def reset!
        @errors = {}
        @presentations = []
      end

      def presentations
        @presentations ||= []
      end

      def define(name, &block)
        presentations << new(name: name, &block)

        perform_validations!
      end

      private

      def error
        print(ERROR_MESSAGE)

        print_errors
      end

      def presentation_not_found_error(name)
        print(PRESENTATION_NOT_FOUND_ERROR_MESSAGE)

        print("Presentation Name: #{name}")
      end

      def print_errors
        errors.each do |key, values|
          print("#{key.to_s.titleize}: #{values.join(', ')}")
        end
      end

      def perform_validations!
        validate_duplicates!
      end

      def validate_duplicates!
        presentation_names = Set.new
        duplicates = Set.new

        presentations.each do |presentation|
          duplicates << presentation.name if presentation_names.include? presentation.name

          presentation_names << presentation.name
        end

        duplicates.each do |duplicate_name|
          errors[:duplicate_names] ||= []

          errors[:duplicate_names] << duplicate_name
        end

        presentations.delete_if do |presentation|
          duplicates.include? presentation.name
        end
      end

      def print(message)
        STDOUT.puts(message)
      end
    end

    attr_reader :name, :window_height, :window_width, :slides

    def initialize(name:, &block)
      @name = name
      @definition = block
      @base = block.binding.receiver
      @window_height, @window_width = IO.console.winsize
      @slides = []
    end

    def run(slide_number = 0)
      instance_eval(&definition)

      slide_number = 0 if slide_number < 0

      slides.drop(slide_number).each_with_index do |slide, index|
        slide.index = slide_number + index + 1

        slide.print
      end
    end

    def slide(&block)
      slides << Slide.new(&block)
    end

    private

    attr_reader :definition, :base
  end
end
