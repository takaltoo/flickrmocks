require 'spec_helper'

describe APP::Helpers do
  before(:each) do
    @helpers = APP::Helpers
    @fixtures = APP::Fixtures.new
  end

  describe 'extension method' do
    it "should have correct extension" do
      @helpers.extension.should == '.marshal'
    end
  end

  describe "fname_fixture method" do
    it "should give correct fixture file when symbol provided" do
      expected_fname = 'sample_file' + @helpers.extension
      @helpers.fname_fixture(:sample_file) == expected_fname
    end
  end

  describe "equivalent? method" do
    it "should detect that the same photo_detail object is equivalent to itself" do
      @helpers.should be_equivalent(@fixtures.photo_details,@fixtures.photo_details)
    end
    it "should detect that the same photo_sizes object is equivalent to itself" do
      @helpers.should be_equivalent(@fixtures.photo_sizes,@fixtures.photo_sizes)
    end
    it "should detect that the same photo object is equivalent to itself" do
      @helpers.should be_equivalent(@fixtures.photos,@fixtures.photos)
    end
    it "should detect that a photo_details object is not equivalent to a photo" do
      @helpers.should_not be_equivalent(@fixtures.photo_details, @fixtures.photos.first)
    end
    it "should detect that a photo_sizes object is not the same as a photo_details object" do
      @helpers.should_not be_equivalent(@fixtures.photo_sizes,@fixtures.photo_details)
    end
  end

  describe "dump/load behavior" do
    it "should be able to dump/load an object without losing data" do
      begin
        fname = "/tmp/#{Time.now}_#{Random.rand}"
        expected = [Random.rand,Random.rand]
        @helpers.dump(expected,fname)
        actual = @helpers.load(fname)
        actual.should == expected
      ensure
        File.delete fname
      end
    end
  end
  
end
    