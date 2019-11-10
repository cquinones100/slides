require './lib/slides/version'
require 'active_support/all'
require './lib/slides/formatters/formatters.rb'

module Slides
  class Error < StandardError; end

  Dir['./lib/slides/**/*.rb'].each do |file|
    constant_name = file
      .split('/')[-1]
      .gsub('.rb', '')
      .split('/').map(&:classify)
      .join('::')

    autoload(constant_name, file)
  end
end
