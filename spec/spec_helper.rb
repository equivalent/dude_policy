require "bundler/setup"
require "dude_policy"
require 'irb'

require "./spec/app/models/user"
require "./spec/app/models/account"
require "./spec/app/models/article"

require "./spec/app/policy/article_policy"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
