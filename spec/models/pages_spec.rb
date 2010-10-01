require 'spec_helper'

describe APP::Pages do
  let(:klass){APP::Pages}
  let(:url){'http://www.example.com'}

  describe "page" do
    it "should return proper page when initialized with string" do
      klass.new(:page => '2').page.should eql(2)
    end
    it "should return proper page when initialized with integer" do
      klass.new(:page => 3).page.should eql(3)
    end
  end

  describe "url" do
    it "should contain url method" do
      klass.new({}).should respond_to(:url)
    end
    it "should return correct urll" do
      klass.new(:url => url).url.should eql(url)
    end
  end

  describe "current_page" do
    it "should respond to current_page" do
      klass.new({}).should respond_to(:current_page)
    end
    it "should properly accept strings for  :current_page" do
      klass.new(:current_page => '3').current_page.should eql(3)
    end
    it "should properly accept integer for :current_page" do
      klass.new(:current_page => 2).current_page.should eql(2)
    end
  end

  describe "current_page?" do
    it "should detect whether page is equal to current_page" do
      klass.new(:current_page => 3, :page => 3).should be_current_page
    end
    it "should detect whether page is NOT equal to current_page" do
      klass.new(:current_page => 3, :page => 4).should_not be_current_page
    end
  end
  
end

  