require 'simplecov'
SimpleCov.start

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

ENV['RACK_ENV'] = 'test'
ENV['ENVIRONMENT'] = 'test'

require 'capybara'
require 'capybara/rspec'
require 'pry'
require 'rake'
require 'simplecov-console'
require_relative '../database_connection_setup'
require_relative '../app.rb'
require_relative 'features/web_helpers'
require_relative 'helper_methods'

Capybara.app = ChitterApp

initialize_test_database

Rake.application.load_rakefile

RSpec.configure do |config|
  config.before(:suite) do
    Rake::Task['setup'].execute
  end
  config.after(:suite) do
    puts
    puts "\e[33mHave you considered running rubocop? It will help you improve your code!\e[0m"
    puts "\e[33mTry it now! Just run: rubocop\e[0m"
  end
end
