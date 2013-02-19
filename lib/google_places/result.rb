module GooglePlaces
  class Result
    attr_accessor :status, :result, :results, :html_attributions, :next_page_token

    def initialize(response)
      require 'json'

      JSON.parse(response).each do |k,v|
        value = case k
                when 'result'
                  GooglePlaces::Place.new(v)
                when 'results'
                  v.map { |attrs| GooglePlaces::Place.new(attrs) }
                else
                  v
                end

        public_send("#{k}=", value) if respond_to?(k)
      end
    end
  end
end