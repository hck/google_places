require "spec_helper"

describe GooglePlaces::Place do
  describe "#initialize" do
    it "should raise ArgumentError if no attributes specified" do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end

    it "should create place successfully" do
      obj = described_class.new('name' => 'fake place')
      obj.should be_instance_of(described_class)
      obj.name.should == 'fake place'
    end
  end

  describe "#attributes" do
    let(:place){ described_class.new('name' => 'fake place') }

    it "should respond to appropriate method" do
      place.should respond_to(:attributes)
    end

    it "should return valid attributes" do
      place.attributes.should == {'name' => 'fake place'}
    end
  end
end
