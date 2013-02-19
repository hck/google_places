require 'rubygems'

require 'google_places'
require 'yaml'

#FactoryGirl.definition_file_paths = [File.join(File.dirname(__FILE__), 'factories')]
#FactoryGirl.find_definitions

options = YAML.load File.read(File.dirname(__FILE__) + '/spec_config.yml')

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true

  config.before(:all) do
    @api_key = options['api_key']
  end
end