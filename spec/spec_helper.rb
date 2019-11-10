require 'bundler/setup'
require 'slides'

require './lib/slides'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    Slides::Presentation.reset!
    allow(STDOUT).to receive(:puts)
    allow_any_instance_of(Slides::Slide)
      .to receive(:system)
      .with('clear')
  end
end
