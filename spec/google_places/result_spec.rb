require "spec_helper"
require "json"

describe GooglePlaces::Result do
  describe "#initialize" do
    it "should raise ArgumentError if response argument is not specified" do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end

    it "should create new instance successfully" do
      described_class.new(JSON.dump({a: 1, b: 2})).should be_instance_of(described_class)
    end

    it "should create place object if result option passed" do
      response = JSON.dump result: {name: 'fake place'}
      result = described_class.new(response)
      result.result.should be_instance_of GooglePlaces::Place
      result.result.name.should == 'fake place'
    end

    it "should create place object for each item of results array passed" do
      places = 3.times.each_with_object([]) do |i,res|
        res << {name: "fake place #{i}"}
      end

      response = JSON.dump results: places
      result = described_class.new(response)
      result.results.should be_instance_of Array
      result.results.size.should == places.size
      result.results.each_with_index do |p,i|
        p.should be_instance_of GooglePlaces::Place
        p.name.should == places[i][:name]
      end
    end
  end
end