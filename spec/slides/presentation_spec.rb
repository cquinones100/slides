require 'coderay'
require 'io/console'

RSpec.describe Slides::Presentation do
  describe 'class methods' do
    describe '.run' do
      context 'when there are errors' do
        context 'when there are presentation errors' do
          it 'prints errors' do
            described_class.errors[:duplicate_names] = ['error']

            expect(STDOUT).to receive(:puts).with(described_class::ERROR_MESSAGE)

            expect(STDOUT).to receive(:puts).with('Duplicate Names: error')

            described_class.run('a_presentation')
          end
        end

        context 'when no name is passed in' do
          it 'prints an error' do
            expect(STDOUT)
              .to receive(:puts)
              .with(described_class::NO_NAME_ERROR_MESSAGE)

            described_class.run
          end
        end

        context 'when the name passed in is not a saved presentation' do
          it 'prints an error' do
            expect(STDOUT)
              .to receive(:puts)
              .with(described_class::PRESENTATION_NOT_FOUND_ERROR_MESSAGE)

            expect(STDOUT)
              .to receive(:puts)
              .with('Presentation Name: a presentation that does not exist')

            described_class.run('a presentation that does not exist')
          end
        end
      end

      context 'when there are no errors' do
        it 'runs the presentation' do
          presentation_double = instance_double(
            described_class,
            name: 'a presentation'
          )

          described_class.presentations << presentation_double

          expect(presentation_double).to receive(:run)

          described_class.run('a presentation')
        end
      end
    end

    describe '.define' do
      it 'saves the definition in presentations' do
        presentation_double = instance_double(
          described_class,
          name: :a_presentation
        )

        allow(described_class).to receive(:new).and_return(presentation_double)

        described_class.define :a_presentation do
          slide {}
        end

        expect(described_class.presentations).to include(presentation_double)
      end
    end
  end

  describe 'validations' do
    context 'when a presentation name already exists' do
      before do
        described_class.define :a_presentation do
          slide {}
        end

        described_class.define :a_presentation do
          slide {}
        end
      end

      it 'does not save the duplicating presentation' do
        expect(described_class.presentations.size).to eq 0
      end

      it 'provides the duplicate names in errors' do
        expect(described_class.errors[:duplicate_names])
          .to include(:a_presentation)
      end
    end
  end

  describe '#run' do
    describe '#slide' do
      it 'clears the screen' do
        described_class.define :a_presentation do
          slide do
            message do
              'hi'
            end
          end
        end

        expect_any_instance_of(Slides::Slide)
          .to receive(:system)
          .with('clear')

        described_class.run(:a_presentation)
      end

      it 'prints the current slide number' do
        allow(IO)
          .to receive(:console)
          .and_return(OpenStruct.new(winsize: [3, 3]))

        described_class.define :a_presentation do
          slide do
            message do
              'hi'
            end
          end

          slide do
            message do
              'hi again'
            end
          end
        end

        expect(STDOUT).to receive(:puts).with('Slide 1 of 2').ordered
        expect(STDOUT).to receive(:puts).with("hi\n").ordered
        expect(STDOUT).to receive(:puts).with('Slide 2 of 2').ordered
        expect(STDOUT).to receive(:puts).with("hi again\n").ordered

        described_class.run(:a_presentation)
      end

      context 'when a slide contains multiple kinds of text' do
        it 'uses all called text' do
          allow(IO)
            .to receive(:console)
            .and_return(OpenStruct.new(winsize: [3, 3]))

          described_class.define :a_presentation do
            slide do
              message do
                'a message'
              end

              code do
                def hi
                  puts 'hi'
                end
              end
            end
          end

          text = <<~RUBY
            def hi
              puts 'hi'
            end
          RUBY

          formatted_code = CodeRay.scan(text.chomp, :ruby).term

          expect(STDOUT).to receive(:puts).with('Slide 1 of 1')

          expect(STDOUT)
            .to receive(:puts)
            .with("a message\n\n" + formatted_code + "\n")

          described_class.run(:a_presentation)
        end
      end
    end
  end

  describe '#message' do
    it 'prints the message with padding' do
      allow(IO).to receive(:console).and_return(OpenStruct.new(winsize: [3, 3]))

      described_class.define :a_presentation do
        slide do
          message do
            'a message'
          end
        end
      end

      expect(STDOUT).to receive(:puts).with('Slide 1 of 1')
      expect(STDOUT).to receive(:puts).with("a message\n")

      described_class.run(:a_presentation)
    end
  end

  describe '#code' do
    it 'prints the message with padding and syntax highlighting' do
      allow(IO).to receive(:console).and_return(OpenStruct.new(winsize: [3, 3]))

      described_class.define :a_presentation do
        slide do
          code do
            class Thing
              def thing
                proc do
                  do_something
                end
              end
            end
          end
        end
      end

      text = <<~RUBY
        class Thing
          def thing
            proc do
              do_something
            end
          end
        end
      RUBY

      expect(STDOUT).to receive(:puts).with('Slide 1 of 1')
      expect(STDOUT)
        .to receive(:puts)
        .with(CodeRay.scan(text.chomp, :ruby).term + "\n")

      described_class.run(:a_presentation)
    end
  end
end
