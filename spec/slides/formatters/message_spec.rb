RSpec.describe Slides::Formatters::Message do 
  describe '#formatted' do
    context 'when text is bolded' do
      context 'when all text is bolded' do
        it 'prints the text bolded' do
          block = proc do
            "'bold'
            hi this is something bolded

            things
            'bold'"
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "\e[1mhi \e[1mthis \e[1mis \e[1msomething \e[1mbolded" \
              "\n\n" \
              "\e[1mthings\e[0m"
            )
        end
      end

      context 'when some text is bolded' do
        it 'prints the text bolded' do
          block = proc do
            "hi this is text

            'bold'
            hi this is something bolded
            'bold'"
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "hi this is text\n\n\e[1mhi \e[1mthis \e[1mis" \
              " \e[1msomething \e[1mbolded\e[0m"
            )
        end
      end
    end

    context 'when text is underlined' do
      context 'when all the text is underlined' do
        it 'prints the text underlined' do
          block = proc do
            "'underline'
            hi this is something underlined
            'underline'"
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "\e[4mhi \e[4mthis \e[4mis \e[4msomething \e[4munderlined\e[0m"
            )
        end
      end

      context 'when some text is underlined' do
        it 'prints the text underlined' do
          block = proc do
            "'underline'
            hi this is something underlined
            'underline'

            hi this is text"
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "\e[4mhi \e[4mthis \e[4mis \e[4msomething \e[4munderlined\e[0m" \
              "\n\n" \
              'hi this is text'
            )
        end
      end

      context 'when adding to an existing formatting' do
        it 'adds underlining to the text' do
          block = proc do
            "'underline,bold'
                hi this is something underlined
            'underline,bold'

            hi this is text"
          end

          formatted_text = described_class.new(&block)

          expect(formatted_text)
            .to eq(
              "\e[4;1mhi \e[4;1mthis \e[4;1mis \e[4;1msomething " \
              "\e[4;1munderlined\e[0m" \
              "\n\n" \
              'hi this is text'
            )
        end
      end
    end
  end
end
