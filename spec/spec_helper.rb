ENV['RAILS_ENV'] ||= 'test'

require_relative 'app/config/environment'
require 'rspec/rails'
require_relative '../lib/sprockets-svg'

RSpec.configure do |config|
  config.order = 'random'
end
