module GooglePlaces
  class Place
    attr_reader :attributes

    def initialize(attrs)
      @attributes = attrs
    end

    def address_components
      attributes['address_components']
    end

    def events
      attributes['events']
    end

    def formatted_address
      attributes['formatted_address']
    end

    def formatted_phone_number
      attributes['formatted_phone_number']
    end

    def international_phone_number
      attributes['international_phone_number']
    end

    def icon
      attributes['icon']
    end

    def id
      attributes['id']
    end

    def geometry
      data = attributes['geometry']

      {
        location: {
          lat: data['location']['lat'],
          lng: data['location']['lat']
        },
        viewport: data['viewport']
      }
    end

    def name
      attributes['name']
    end

    def opening_hours
      data = attributes['opening_hours']

      {
        open_now: data['open_now'],
        periods: data['periods'].map do |period|
          {
            open: {
              day: period['open']['day'],
              time: period['open']['time']
            },
            close: {
              day: period['close']['day'],
              time: period['close']['time']
            }
          }
        end
      }

    end

    def rating
      attributes['rating']
    end

    def reference
      attributes['reference']
    end

    def reviews
      attributes['reviews']
    end

    def types
      attributes['types']
    end

    def url
      attributes['url']
    end

    def utc_offset
      attributes['utc_offset']
    end

    def vicinity
      attributes['vicinity']
    end

    def website
      attributes['website']
    end
  end
end