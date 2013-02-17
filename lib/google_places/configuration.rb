require 'singleton'

module GooglePlaces
  class Configuration
    include Singleton

    attr_reader :api_key, :language

    DEFAULTS = {language: :en}

    def configure(options)
      @api_key, @language = DEFAULTS.merge(options).values_at(:api_key, :language)

      raise InvalidApiKeyError if api_key.nil? || api_key.empty?
    end

    class InvalidApiKeyError < StandardError; end
  end
end