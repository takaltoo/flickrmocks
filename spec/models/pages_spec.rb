require 'spec_helper'

describe APP::Api do
  before(:each) do
    @api = APP::Api
    @pages = APP::Pages
  end

  describe "page" do
    it "should return proper page when initialized with string" do
      @pages.new(:page => '2').page.should == 2
    end
    it "should return proper page when initialized with integer" do
      @pages.new(:page => 3).page.should == 3
    end
  end

  describe "url" do
    it "should contain url method" do
      @pages.new({}).should respond_to(:url)
    end
    it "should return correct urll" do
      url = 'http://www.example.com/'
      @pages.new(:url => url).url.should == url
    end
  end

  describe "current_page" do
    it "should respond to current_page" do
      @pages.new({}).should respond_to(:current_page)
    end
    it "should properly accept strings for  :current_page" do
      @pages.new(:current_page => '3').current_page.should == 3
    end
    it "should properly accept integer for :current_page" do
      @pages.new(:current_page => 2).current_page.should == 2
    end
  end

  describe "current_page?" do
    it "should detect whether page is equal to current_page" do
      @pages.new(:current_page => 3, :page => 3).should be_current_page
    end
    it "should detect whether page is NOT equal to current_page" do
      @pages.new(:current_page => 3, :page => 4).should_not be_current_page
    end
  end
  
end

  