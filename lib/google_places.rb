require 'google_places/configuration'
require 'google_places/query'
require 'google_places/version'

module GooglePlaces
  extend self

  SEARCH_URL = 'https://maps.googleapis.com/maps/api/place/search/json'

  attr_reader :configuration, :last_response

  private :last_response

  def configure(options)
    @configuration = Configuration.instance
    @configuration.configure(options)
  end

  def search(query, options={})
    @last_response = Query.new(query, options).response
  end

  private
  def get_results(response)
    require 'ostruct'

    response['results'].each_with_object([]) do |rec,acc|
      acc << OpenStruct.new(rec)
    end
  end

  def next_page_token
    last_response && last_response['next_page_token']
  end
end