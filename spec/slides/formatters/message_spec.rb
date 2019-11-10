RSpec.describe Slides::Formatters::Message do 
  describe '#formatted' do
    context 'when text is bolded' do
      context 'when all text is bolded' do
        it 'prints the text bolded' do
          block = proc do
            '**hi this is something bolded**'
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq('\e[1mhi \e[1mthis \e[1mis \e[1msomething \e[1mbolded')
        end
      end

      context 'when some text is bolded' do
        it 'prints the text bolded' do
          block = proc do
            hi this is text

            '**hi this is something bolded**'
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "hi this is text\n\n\\e[1mhi \\e[1mthis \\e[1mis" \
              ' \\e[1msomething \\e[1mbolded'
            )
        end
      end
    end
  end
end
