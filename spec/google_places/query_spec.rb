require "spec_helper"

describe GooglePlaces::Query do
  let(:query){ {location: '111', sensor: true, radius: 1000} }

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

  describe "#response" do
    let(:config) do
      GooglePlaces.configure(api_key: 'test_api_key')
      described_class.new(query)
    end

    it "should do request to a proper uri" do
      uri = URI(GooglePlaces::SEARCH_URL)
      uri.query = URI.encode_www_form(query.merge(key: 'test_api_key'))

      Net::HTTP.stub(:get_response).with(uri).and_return(true)
      config.response
    end
  end

  describe "private #build_query" do
    let(:config) do
      GooglePlaces.configure(api_key: 'test_api_key')
      described_class.new(query.merge(types: [:type1, :type2], rankby: :distance))
    end

    it "should join types by pipes if types passed as an array" do
      res = config.send(:build_query)
      res[:types].should == 'type1|type2'
    end

    it "should delete radius if rankby query param set to 'distance'" do
      res = config.send(:build_query)
      res.key?(:radius).should be_false
    end
  end
end