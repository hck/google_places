require 'net/http'

module GooglePlaces
  class Query
    VALID_QUERY_PARAMS = [:location, :radius, :sensor, :keyword, :language, :name, :rankby, :types, :pagetoken]
    REQUIRED_QUERY_PARAMS = [:location, :radius, :sensor]

    attr_reader :query, :options

    def initialize(query, options={})
      @query, @options = query.select{|k,| VALID_QUERY_PARAMS.include?(k)}, options

      if (query.keys & REQUIRED_QUERY_PARAMS).sort != REQUIRED_QUERY_PARAMS.sort && !query.key?(:pagetoken)
        raise InvalidRequiredParams
      end
    end

    def response
      require 'json'

      uri = URI(GooglePlaces::SEARCH_URL)
      uri.query = URI.encode_www_form(build_query)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      response = http.start do |agent|
        agent.get(uri.path + '?' + uri.query)
      end

      JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
    end

    private
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
                       end

        # join types by pipes (|)
        q[:types] = q[:types].join('|') if q.key?(:types) && q[:types].is_a?(Array)

        # do not use radius if places are fetched by distance (radius is already set to 50 km)
        q.delete(:radius) if q.key?(:rankby) && q[:rankby].to_sym == :distance
      end
    end

    class InvalidRequiredParams < StandardError; end
  end
end