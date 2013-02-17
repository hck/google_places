require 'rubygems'

require 'google_places'

#FactoryGirl.definition_file_paths = [File.join(File.dirname(__FILE__), 'factories')]
#FactoryGirl.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
end