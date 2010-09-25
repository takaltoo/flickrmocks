require 'spec_helper'

describe APP::Fixtures do
  before(:each) do
    @fixtures = APP::Fixtures.new
  end

  describe "photos" do
    it "should respond to :photos" do
      @fixtures.should respond_to(:photos)
    end
    it "returned object should be ResponseList class" do
      @fixtures.photos.class == FlickRaw::ResponseList
    end
    it "should contain collection of type FlickRaw::Response" do
      @fixtures.photos.each do |photo|
        photo.class.should be_equal(FlickRaw::Response)
      end
    end
    it "should contain photo elements that respond to photo methods" do
      @fixtures.photos.each do |photo|
        [:id, :owner, :secret, :server, :farm, :title, :ispublic, :isfriend, :isfamily, :license, :flickr_type].each do |method|
          photo.should respond_to(method)
        end
      end
    end
  end

  describe "photo_details" do
    it "should respond to :photo_details" do
      @fixtures.should respond_to(:photo_details)
    end
    it "should return object of class FlickRaw::Response" do
      @fixtures.photo_details.class.should be_equal(FlickRaw::Response)
    end
    it "should return an object that responds to expected methods" do
      [:id, :secret, :server, :farm, :dateuploaded, :isfavorite, :license, :rotation,
        :owner, :title, :description, :visibility, :dates, :views, :editability, :usage,
        :comments, :notes, :tags, :urls, :media].each do |method|
        @fixtures.photo_details.should respond_to(method)
      end
    end
  end

  describe "photo" do
    it "should respond to :photo method" do
      @fixtures.should respond_to(:photo)
    end
    it "should return an object of proper class" do
      @fixtures.photo.class.should be_equal(FlickRaw::Response)
    end
    it "should return an object that respond to expected methods" do
      [:id, :owner, :secret, :server, :farm, :title, :ispublic,
        :isfriend, :isfamily, :license].each do |method|
        @fixtures.photo.should respond_to(method)
      end
    end
  end

  describe "photo_sizes" do
    it "should respond to :photo_sizes method" do
      @fixtures.should respond_to(:photo_sizes)
    end
    it "should return an object of proper class" do
      @fixtures.photo_sizes.class.should be_equal(FlickRaw::ResponseList)
    end
    it "should return an object that respond to expected methods" do
      [:canblog, :canprint, :candownload, :size].each do |method|
        @fixtures.photo_sizes.should respond_to(method)
      end
    end

    describe "size method" do
      before(:each) do
        @size = @fixtures.photo_sizes.size
      end
      it "should return object that has an :each method" do
        @size.should respond_to(:each)
      end
      
      describe ":each" do
        it "should yield objects that respond to proper methods " do
          @size.each do |size|
            [:label, :width, :height, :source, :url, :media, :flickr_type].each do |method|
              size.should respond_to(method)
            end
          end
        end      
      end
    end

    describe ':interesting_photos' do
      it "should respond to interesting_photos" do
        @fixtures.should respond_to(:interesting_photos)
      end
      it "should return an object that responds to expected methods" do
        [:page, :pages, :perpage, :total, :photo].each do |method|
          @fixtures.interesting_photos.should respond_to(method)
        end
      end
      describe ":photo" do
        before(:each) do
          @photos = @fixtures.interesting_photos.photo
        end
        it "should yield an object that responds to :each" do
          @photos.should respond_to(:each)
        end
        it "should yield objects that respond to proper methods" do
          @photos.each do |photo|
            [:id, :owner, :secret, :server, :farm, :title, :ispublic,:isfriend,
              :isfamily, :license].each do |method|
              photo.should respond_to(method)
            end
          end
        end
      end
    end

    describe ":author_photos" do
      it "should respond to :author_photos" do
        @fixtures.should respond_to(:author_photos)
      end
      it "should return an object that responds to the expected methods" do
        author = @fixtures.author_photos
        [:page, :pages, :perpage, :total, :photo].each do |method|
          author.should respond_to(method)
        end
      end
      describe ":photo" do
        before(:each) do
          @author_photos = @fixtures.author_photos
        end
        it "should return an object that responds to :each" do
          @author_photos.should respond_to(:each)
        end
        it "should return an object that responds to proper methods" do
          @author_photos.each do |author_photo|
            [:id, :owner, :secret, :server, :farm, :title, :ispublic,
              :isfriend, :isfamily, :license].each do |method|
              author_photo.should respond_to(method)
            end
          end
        end
      end
    end

    describe "APP::Fixtures.repository" do
      it "should respond to a :repository class method" do
        APP::Fixtures.should respond_to(:repository)
      end
      it "should return a proper :repository" do
        expected = File.expand_path(File.dirname(__FILE__) + '/../fixtures') + '/'
        APP::Fixtures.repository.should == expected
      end
      
    end

  end
end




