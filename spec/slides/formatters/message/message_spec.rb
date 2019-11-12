RSpec.describe Slides::Formatters::Message do 
  describe '#formatted' do
    subject { described_class.new(self, &block) }

    context 'nested formatting' do
      let(:block) do
        proc do
          "'bold'
          'underline'
          hi this is something bolded

          things
          'underline'
          'bold'"
        end
      end

      let(:expected_text) do
        "\e[1;4mhi \e[1;4mthis \e[1;4mis \e[1;4msomething \e[1;4mbolded" \
        "\n\e[1;4m\n" \
        "\e[1;4mthings\e[0m"
      end

      it { is_expected.to eq expected_text }
    end

    context 'multiple formatting' do
      let(:block) do
        proc do
          "'bold'
          this is bolded
          'bold'

          'underline'
          this is underlined
          'underline'"
        end
      end

      let(:expected_text) do
        "\e[1mthis \e[1mis \e[1mbolded\e" \
        "[0m\n\n\e[4mthis \e[4mis \e[4munderlined\e[0m"
      end

      it { is_expected.to eq expected_text }
    end

    context 'inline formatting' do
      let(:block) do
        proc do
          "'bold' this is bolded 'bold' 'underline' this is underlined 'underline'"
        end
      end

      let(:expected_text) do
        "\e[1mthis \e[1mis \e[1mbolded\e" \
        "[0m \e[4mthis \e[4mis \e[4munderlined\e[0m"
      end

      it { is_expected.to eq expected_text }
    end
  end
end
