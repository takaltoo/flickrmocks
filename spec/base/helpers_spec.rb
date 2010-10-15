require 'spec_helper'

describe APP::Helpers do

    let(:helpers) {APP::Helpers}
    let(:fixtures) {APP::Fixtures.new}


  describe 'extension method' do
    it "should have correct extension" do
      helpers.extension.should == '.marshal'
    end
  end

  describe "fname_fixture method" do
    it "should give correct fixture file when symbol provided" do
      expected_fname = 'sample_file' + helpers.extension
      helpers.fname_fixture(:sample_file).should == expected_fname
    end
  end

  describe "equivalent? method" do
    it "should detect that the same photo_detail object is equivalent to itself" do
      helpers.should be_equivalent(fixtures.photo_details,fixtures.photo_details)
    end
    it "should detect that the same photo_sizes object is equivalent to itself" do
      helpers.should be_equivalent(fixtures.photo_sizes,fixtures.photo_sizes)
    end
    it "should detect that the same photo object is equivalent to itself" do
      helpers.should be_equivalent(fixtures.photos,fixtures.photos)
    end
    it "should detect that a photo_details object is not equivalent to a photo" do
      helpers.should_not be_equivalent(fixtures.photo_details, fixtures.photos.first)
    end
    it "should detect that a photo_sizes object is not the same as a photo_details object" do
      helpers.should_not be_equivalent(fixtures.photo_sizes,fixtures.photo_details)
    end
  end

  describe "dump/load behavior" do
    it "should be able to dump/load an object without losing data" do
      begin
        fname = "/tmp/#{Time.now}_#{Random.rand}"
        expected = [Random.rand,Random.rand]
        helpers.dump(expected,fname)
        actual = helpers.load(fname)
        actual.should == expected
      ensure
        File.delete fname
      end
    end
  end

  describe "to_param" do
    it "should be able to translate a basic hash to parameters" do
      hash =  {:search_terms=>"iran", :page=>1}
      helpers.to_param(hash).should == "page=1&search_terms=iran"
    end
    it "should escape special characters in keys" do
      hash = {:'search_&@#$terms'=>"iran"}
      helpers.to_param(hash).should == "search_%26%40%23%24terms=iran"
    end
    it "should escape special characters in value" do
      hash = {:search_terms => 'iran!@#$%po&*()'}
      helpers.to_param(hash).should == "search_terms=iran%21%40%23%24%25po%26%2A%28%29"
    end
  end
  
end
    