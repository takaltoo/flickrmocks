require 'spec_helper'

describe APP::Api do
  let(:api) {APP::Api}

  describe "default" do
    it "should give proper value if string given" do
      api.default(:per_page).should == api.defaults[:per_page]
    end
    it "should give proper valie if symbol given" do
      api.default('per_page').should  == api.defaults[:per_page]
    end
  end
  
  describe "size" do
    it "should return proper size with symbol" do
      api.size(:size => 'small').should == :small
    end
    it "should return lowercase version of the key" do
      api.size({:size => 'HeLlO'}).should == :hello
    end
    it "should return nil if no size given" do
      api.size.should be_nil
    end
    it "should symbolize keys with spaces" do
      api.size(:size => 'medium 640').should  == :'medium 640'
    end
  end
end
