require "spec_helper"

describe GooglePlaces::Configuration do
  it "should throw error on initialize" do
    expect{ described_class.new }.to raise_error
  end

  it "should respond to ::instance" do
    described_class.should respond_to(:instance)
  end
  
  describe "#configure" do
    let(:instance){ described_class.instance }
    
    it "should respond to #configure" do
      instance.should respond_to(:configure)
    end

    it "should raise ArgumentError if options not specified" do
      expect{ instance.configure }.to raise_error(ArgumentError)
    end

    it "should raise InvalidApiKey error if api_key is empty" do
      expect{ instance.configure(api_key: nil) }.to raise_error(GooglePlaces::Configuration::InvalidApiKeyError)
    end

    it "should assign options properly" do
      instance.configure(api_key: '111', language: :lang)
      instance.api_key.should == '111'
      instance.language.should == :lang
    end

    it "should assign default values for not specified options (except api_key)" do
      instance.configure(api_key: '111')
      instance.language.should == described_class::DEFAULTS[:language]
    end
  end
end