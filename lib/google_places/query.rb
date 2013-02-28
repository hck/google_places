require 'net/http'

module GooglePlaces
  class Query
    VALID_QUERY_PARAMS = {
      search: [:location, :radius, :sensor, :keyword, :language, :name, :rankby, :types, :pagetoken],
      details: [:reference, :sensor]
    }
    REQUIRED_QUERY_PARAMS = [:location, :radius, :sensor]

    SEARCH_URL = 'https://maps.googleapis.com/maps/api/place/search/json'
    DETAILS_URL = 'https://maps.googleapis.com/maps/api/place/details/json'

    attr_reader :query, :options

    def initialize(query, options={})
      type = options[:type] || :search

      if type == :details
        raise InvalidRequiredParams unless query.key?(:reference)
      else
        if (query.keys & REQUIRED_QUERY_PARAMS).sort != REQUIRED_QUERY_PARAMS.sort && !query.key?(:pagetoken)
          raise InvalidRequiredParams
        end
      end

      @query, @options = query.select{|k,| VALID_QUERY_PARAMS[type].include?(k)}, options
    end

    def search
      result SEARCH_URL
    end

    def details
      result DETAILS_URL
    end

    private
    def result(url=SEARCH_URL)
      uri = URI(url)
      uri.query = URI.encode_www_form(build_query)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      response = http.start do |agent|
        agent.get(uri.path + '?' + uri.query)
      end

      GooglePlaces::Result.new(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    def build_query
      query.clone.tap do |q|
        q[:key] = GooglePlaces.configuration.api_key

        #join latitude and longitude by comma (,)
        q[:location] = case q[:location]
                       when Array
                         q[:location].join(',')
                       when Hash
                         q[:location].values_at(:lat, :lng).join(',')
                       else
                         q[:location]
                       end if q.key?(:location)

        # join types by pipes (|)
        q[:types] = q[:types].join('|') if q.key?(:types) && q[:types].is_a?(Array)

        # do not use radius if places are fetched by distance (radius is already set to 50 km)
        q.delete(:radius) if q.key?(:rankby) && q[:rankby].to_sym == :distance
      end
    end

    class InvalidRequiredParams < StandardError; end
  end
end