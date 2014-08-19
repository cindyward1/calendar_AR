require 'bundler/setup'
Bundler.require(:default, :test)

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Event.all.each { |event| event.destroy }
  end
end

