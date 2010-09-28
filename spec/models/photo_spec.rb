require 'spec_helper'

describe APP::Api do
  before(:each) do
    @api = APP::Api
    @pages = APP::Pages
    @fixtures = APP::Fixtures.new
    @photo_fixture = @fixtures.photo
    @photo = APP::Photo.new @photo_fixture
  end



  describe "delegated methods" do
    it "should be object of the proper class" do
      @photo.should be_a(APP::Photo)
    end
    it "should return proper :id" do
      @photo.id.should == @photo_fixture['id']
    end
    it "should return proper :owner" do
      @photo.owner.should == @photo_fixture['owner']
    end
    it "should return correct server" do
      @photo.server.should == @photo_fixture['server']
    end
    it "should return correct farm" do
      @photo.farm.should == @photo_fixture['farm']
    end
    it "should return correct :ispublic" do
      @photo.ispublic.should == @photo_fixture['ispublic']
    end
    it "should give correct :isfamily" do
      @photo.isfamily.should == @photo_fixture['isfamily']
    end
    it "should give correct :flickr_type" do
      @photo.flickr_type.should == 'photo'
    end
  end

  describe "photo url methods" do
    before(:each) do
      @base_url = "http://farm#{@photo_fixture['farm']}.static.flickr.com/#{@photo_fixture['server']}/#{@photo_fixture['id']}_#{@photo_fixture['secret']}"
    end
    it "should return :square url" do
      @photo.square.should == "#{@base_url}_s.jpg"
    end
    it "should return :thumbnail url" do
      @photo.thumbnail.should == "#{@base_url}_t.jpg"
    end
    it "should return :small url" do
      @photo.small.should == "#{@base_url}_m.jpg"
    end
    it "should return :medium url" do
      @photo.medium.should == "#{@base_url}.jpg"
    end
    it "should return :large url" do
      @photo.large.should == "#{@base_url}_b.jpg"
    end
    it "should return :medium_640 url" do
      @photo.medium_640.should == "#{@base_url}_z.jpg"
    end
    it "should return :medium 640 url" do
      @photo.send(:'medium 640').should == "#{@base_url}_z.jpg"
    end
  end

  describe "owner_url" do
    it "should respond to :owner_url" do
      @photo.should respond_to(:owner_url)
    end
    it "should return proper :owner_url" do
      @photo.owner_url.should == "http://www.flickr.com/photos/#{@photo_fixture['owner']}/#{@photo_fixture['id']}"
    end
  end

  describe "owner_id" do
    it "should respond to :owner_id" do
      @photo.should respond_to(:owner_id)
    end
    it "should return :owner_id" do
      @photo.owner_id.should == @photo_fixture['owner']
    end
  end
  describe "owner" do
    it "should respond to :owner" do
      @photo.should respond_to(:owner)
    end
    it "should return :owner" do
      @photo.owner.should == @photo_fixture['owner']
    end
  end
end
