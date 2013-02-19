require "spec_helper"

describe GooglePlaces::Query do
  let(:query){ {location: '111', sensor: true, radius: 1000} }
  let(:lat_lng){ {lat: 50.426585499999995, lng: 30.504084000000002} }

  describe "#initialize" do
    it "should initialize new object if query param specified" do
      obj = described_class.new(query)
      obj.should be_instance_of(described_class)
      obj.query.should == query
      obj.options.should == {}
    end

    it "should raise ArgumentError if query not specified" do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end

    it "should raise InvalidRequiredParams if not all required query options specified" do
      described_class::REQUIRED_QUERY_PARAMS.each do |p|
        expect{ described_class.new(p => 'value') }.to raise_error(described_class::InvalidRequiredParams)
      end
    end
  end

  describe "#search" do
    it "should do request to a proper uri" do
      GooglePlaces.configure(api_key: 'test_api_key')
      query_obj = described_class.new(query)

      uri = URI(described_class::SEARCH_URL)
      uri.query = URI.encode_www_form(query.merge(key: 'test_api_key'))

      Net::HTTP.stub(:get_response).with(uri).and_return(true)
      query_obj.search
    end

    it "should receive valid response" do
      GooglePlaces.configure(api_key: @api_key)
      query_obj = described_class.new query.merge(location: lat_lng)
      query_obj.search.should be_instance_of(GooglePlaces::Result)
    end
  end

  describe "#details" do

  end

  describe "private #build_query" do
    let(:query_obj) do
      GooglePlaces.configure(api_key: 'test_api_key')
      described_class.new(query.merge(types: [:type1, :type2], rankby: :distance))
    end

    it "should do nothing with location if it specifiad as string" do
      query_obj.send(:build_query)[:location].should == query[:location]
    end

    it "should join latitude & longitude in location hash with comma" do
      obj = described_class.new query.merge(location: lat_lng)
      obj.send(:build_query)[:location].should == lat_lng.values_at(:lat, :lng).join(',')
    end

    it "should join latitude & longitude in location array with comma" do
      obj = described_class.new query.merge(location: lat_lng.values)
      obj.send(:build_query)[:location].should == lat_lng.values.join(',')
    end

    it "should join types by pipes if types passed as an array" do
      res = query_obj.send(:build_query)
      res[:types].should == 'type1|type2'
    end

    it "should delete radius if rankby query param set to 'distance'" do
      res = query_obj.send(:build_query)
      res.key?(:radius).should be_false
    end
  end
end