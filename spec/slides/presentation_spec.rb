RSpec.describe Slides::Presentation do
  describe 'class methods' do
    describe '.run' do
      context 'when there are errors' do
        context 'when there are presentation errors' do
          it 'prints errors' do
            described_class.errors[:duplicate_names] = ['error']

            expect(STDIN).to receive(:puts).with(described_class::ERROR_MESSAGE)

            expect(STDIN).to receive(:puts).with('Duplicate Names: error')

            described_class.run('a_presentation')
          end
        end

        context 'when no name is passed in' do
          it 'prints an error' do
            expect(STDIN)
              .to receive(:puts)
              .with(described_class::NO_NAME_ERROR_MESSAGE)

            described_class.run
          end
        end

        context 'when the name passed in is not a saved presentation' do
          it 'prints an error' do
            expect(STDIN)
              .to receive(:puts)
              .with(described_class::PRESENTATION_NOT_FOUND_ERROR_MESSAGE)

            expect(STDIN)
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
    it 'calls all slides' do
      class AThing
        def self.call; end

        def self.other_call; end
      end

      described_class.define :a_presentation do
        slide { AThing.call }
        slide { AThing.other_call }
      end

      expect(AThing).to receive(:call).ordered
      expect(AThing).to receive(:other_call).ordered

      described_class.run(:a_presentation)
    end
  end
end
