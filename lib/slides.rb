require 'slides/version'
require 'active_support/all'

module Slides
  class Error < StandardError; end

  Dir['./lib/slides/**/*.rb'].each do |file|
    autoload(
      file.split('/')[-1].gsub('.rb', '').classify,
      file
    )
  end
end
