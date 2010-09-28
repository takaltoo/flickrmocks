require 'spec_helper'

describe APP::Api do

  before(:each) do
    @api = APP::Api
    @fixtures = APP::Fixtures.new
    @photo = @fixtures.photo
    @photos = @fixtures.photos
    @sizes = @fixtures.photo_sizes
    @photo_details = @fixtures.photo_details
    @interesting = @fixtures.interesting_photos
  end

  describe "@defaults class isntance variables" do
    before(:each) do
      @defaults = @api.defaults.clone
    end
    after(:each) do
      @api.defaults = @defaults
    end
    it "should contain expected keys" do
      @api.defaults.keys.sort.should  == [:per_page,:license,:media,:extras,:tag_mode,:flickr_tag_modes].sort
    end

    it "should be able to set the values" do
      expected = "randmonbooboo"
      @api.defaults.keys.each do |k|
        @api.defaults[k] = expected
        @api.defaults[k].should be_equal(expected)
      end
    end
  end
  
  describe "search" do
    before(:each) do
      flickr.photos.stubs(:search).returns(@photos)
      @search_terms = {:search_terms => 'iran'}
      @base_url = 'http://www.example.com/'
      @api_photos = @api.photos({:per_page=>'5',:search_terms=>'iran',:base_url=> @base_url})
    end
    it "should return an object of a proper class" do
      @api_photos.class.should  == APP::Photos
    end
    it "should return proper search_terms" do
      @api_photos.search_terms.should == 'iran'
    end
    it "should return proper search_url" do
      @api_photos.search_url.should  == @base_url + '?page=1&search_terms=iran'
    end
  end

  describe "photos" do
    before(:each) do
      flickr.photos.stubs(:getInfo).returns(@photo)
      @photo_info = @api.photo({:photo =>@photo.id,:secret => @photo.secret})
    end
    it "should return an object of the proper class" do
      @photo_info.class.should == APP::Photo
    end
    it "should return object with proper id" do
      @photo_info.id.should == @photo.id
    end
    it "should return object with proper secret" do
      @photo_info.secret.should == @photo.secret
    end
  end

  describe "photo_sizes" do
    before(:each) do
      flickr.photos.stubs(:getSizes).returns(@sizes)
      @small_photo = APP::PhotoSize.new(@sizes[0])
      @photo_sizes = @api.photo_sizes(:photo => @small_photo.id, :secret => @small_photo.secret)
    end
    it "should return object of a proper class" do
      @photo_sizes.class.should == APP::PhotoSizes
    end
    it "should return object of proper id" do
      @photo_sizes[0].id.should == @small_photo.id
    end
    it "should return object with proper secret" do
      @photo_sizes[0].secret.should == @small_photo.secret
    end
    it "should return correct number of photo sizes" do
       @photo_sizes.available_sizes.count.should == @sizes.count
    end
  end

  describe "photo_details" do
    before(:each) do
      flickr.photos.stubs(:getSizes).returns(@sizes)
      flickr.photos.stubs(:getInfo).returns(@photo)
      @photo_details = @api.photo_details(:photo => @photo["id"],
                                                     :secret => @photo["secret"])
    end
    it "should return an object of the proper class" do
      @photo_details.class.should == APP::PhotoDetails
    end
    it "should return proper class when called :sizes" do
      @photo_details.sizes.class == APP::PhotoSizes
    end
    it "should return a photo with proper id" do
      @photo_details.id.should == @photo["id"]
    end
    
  end

  describe "interesting_photos" do
    before(:each) do
      flickr.interestingness.stubs(:getList).returns(@interesting)
      @base_url = 'http:://www.example.com/'
      @date = '2004-11-20'

      @interesting_photos = @api.interesting_photos({:date => @date,:base_url => @base_url})
    end
    it "should return object of proper class" do
      @interesting_photos.class.should == APP::Photos
    end
    it "should return proper date for photo" do
      @interesting_photos.date == ''
    end
    it "should return proper search_url" do
      @interesting_photos.search_url.should == @base_url + '?' + "date=#{@date}&page=1"
    end
  end

end