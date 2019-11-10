module Slides
  module Formatters
    Dir['./lib/slides/formatters/**/*.rb'].each do |file|
      constant_name = file
        .split('/')[-1]
        .gsub('.rb', '')
        .split('/').map(&:classify)
        .join('::')

      autoload(constant_name, file)
    end
  end
end
