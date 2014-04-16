ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require_relative '../lib/sprockets-svg'

require 'rspec/rails'

RSpec.configure do |c|
  c.filter_run_excluding not_jruby: RUBY_PLATFORM == 'java'
end


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
