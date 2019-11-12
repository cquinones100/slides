require './lib/slides'

Slides::Presentation.define 'Test Presentation' do
  def slide_title(title, text)
    "'blue' #{title}: 'blue' 'green' #{text} 'green'"
  end

  slide do
    message do
      "'bold'
      'underline'
      Welcome to my presentation
      'underline'
      'bold'"
    end
  end

  slide do
    message do
      "This presentation is a ruby program.
      Throughout the progam, I'll use Pry to pause execution and run code
      examples"
    end
  end

  slide do
    message do
      slide_title('Intro', 'What is Metaprogramming?')
    end
  end

  slide do
    message do
      "From 'blue' wikipedia: 'blue' Metaprogramming is a programming technique
      in which computer programs have the ability to treat other programs as
      their data. It means that a program can be designed to read, generate,
      analyze or transform other programs, and even modify itself while running"
    end
  end

  slide do
    message do
      "In flexible and dynamic languages like Ruby, Metaprogramming can
      be leveraged by frameworks, libraries, utilities and to dynamically
      generate configurations with rich 'blue'Domain Specific Languages'blue'
      (DSLs) and update class definitions on the fly."
    end
  end

  slide do
    message do
      "'red' Example: 'red' FactoryBot"
    end

    wait_for_input do
      system 'chrome-cli open https://github.com/thoughtbot/factory_bot'

      clear
    end
  end

  slide do
    message do
      slide_title('Section One', 'Self')
    end
  end

  slide do
    message do
      "'underline'
      'bold'
      Hi look at this code
      'bold'
      'underline'"
    end

    code do
      class Hello
        def thing
          puts 'hi'
        end

        private

        def thing
          require 'pry'
          binding.pry
        end
      end
    end
  end
end

Slides::Presentation.run 'Test Presentation', ARGV[0] || 0
