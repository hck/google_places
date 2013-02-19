require 'google_places/configuration'
require 'google_places/query'
require 'google_places/place'
require 'google_places/result'
require 'google_places/version'

module GooglePlaces
  extend self

  attr_reader :configuration, :last_result

  private :last_result

  def configure(options)
    @configuration = Configuration.instance
    @configuration.configure(options)
  end

  def search(query, options={})
    @last_result = Query.new(query, options).search
  end

  def details(query)
    @last_result = Query.new(query, options).details
  end

  private
  def next_page_token
    last_result && last_result.next_page_token
  end
end