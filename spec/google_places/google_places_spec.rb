require "spec_helper"

describe GooglePlaces do
  describe "::configure" do
    it "should respond to ::configure" do
      described_class.should respond_to(:configure)
    end
  end

  describe "::search" do
    it "should respond to ::search" do
      described_class.should respond_to(:search)
    end
  end
end
