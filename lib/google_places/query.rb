require 'net/http'

module GooglePlaces
  class Query
    VALID_QUERY_PARAMS = [:location, :radius, :sensor, :keyword, :language, :name, :rankby, :types, :pagetoken]
    REQUIRED_QUERY_PARAMS = [:location, :radius, :sensor]

    attr_reader :query, :options

    def initialize(query, options={})
      @query, @options = query.select{|k,| VALID_QUERY_PARAMS.include?(k)}, options

      raise InvalidRequiredParams if (query.keys & REQUIRED_QUERY_PARAMS).sort != REQUIRED_QUERY_PARAMS.sort
    end

    def response
      uri = URI(GooglePlaces::SEARCH_URL)
      uri.query = URI.encode_www_form(build_query)

      response = Net::HTTP.get_response(uri)

      response.body if response.is_a?(Net::HTTPSuccess)
    end

    private
    def build_query
      query.clone.tap do |q|
        q[:key] = GooglePlaces.configuration.api_key

        # join types by pipes (|)
        q[:types] = q[:types].join('|') if q.key?(:types) && q[:types].is_a?(Array)

        # do not use radius if places are fetched by distance (radius is already set to 50 km)
        q.delete(:radius) if q.key?(:rankby) && q[:rankby].to_sym == :distance
      end
    end

    class InvalidRequiredParams < StandardError; end
  end
end