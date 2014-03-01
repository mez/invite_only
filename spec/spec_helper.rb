$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'database_cleaner'
require 'invite_only'
require 'rspec/rails'
require 'rails'

config = YAML::load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
#ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite'])
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',:database => ':memory:')


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_base_class_for_anonymous_controllers = true
end

# Setup a test app
module NightAtTheRoxbury
  class Application < Rails::Application; end
end

NightAtTheRoxbury::Application.config.secret_token = "KeUXs+xVS6fmtRe4TPw8sK5IC2T3ceL9DPa7S35Jb5+YzAqWREyoUA=="
NightAtTheRoxbury::Application.config.secret_key_base = "KeUXs+xVS6fmtRe4TPw8sK5IC2T3ceL9DPa7S35Jb5+YzAqWREyoUA=="