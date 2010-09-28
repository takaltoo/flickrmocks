require 'spec_helper'

describe APP::CustomMarshal do
  before(:each) do
    @helpers  = APP::Helpers
    @fixtures = APP::Fixtures.new
  end
  
  it "should properly marshal/unmarshal Photos object" do
    original = @fixtures.photos
    marshalled = Marshal.load(Marshal.dump(original))
    @helpers.equivalent?(original,marshalled).should be_true
  end

  it "should properly marshal/unmarshal PhotoSizes object" do
    original = @fixtures.photo_sizes
    marshalled = Marshal.load(Marshal.dump(original))
    @helpers.equivalent?(original,marshalled).should be_true
  end

  it "should properly marshal/unmarshal PhotoDetails object" do
    original = @fixtures.photo_details
    marshalled = Marshal.load(Marshal.dump(original))
    @helpers.equivalent?(original,marshalled).should be_true
  end

  it "should properly marshal/unmarshal Photo objects" do
    original = @fixtures.photo
    marshalled = Marshal.load(Marshal.dump(original))
    @helpers.equivalent?(original,marshalled).should be_true
  end

  it "should properly marshal/unmarshal interesting photos" do
    original = @fixtures.interesting_photos
    marshalled = Marshal.load(Marshal.dump(original))
    @helpers.equivalent?(original,marshalled).should be_true
  end

end

