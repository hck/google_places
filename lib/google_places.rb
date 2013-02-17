require 'google_places/configuration'
require 'google_places/query'
require 'google_places/version'

module GooglePlaces
  extend self

  SEARCH_URL = 'https://maps.googleapis.com/maps/api/place/search/json'

  attr_reader :configuration

  def configure(options)
    @configuration = Configuration.instance
    @configuration.configure(options)
  end

  def search(query, options={})
    Query.new(query, options).response
  end
end