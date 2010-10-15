require 'spec_helper'
require 'ruby-debug'
describe APP::Api do
    let(:api) { APP::Api }
    let(:fixtures) { APP::Fixtures.new }
    let(:photo)  {fixtures.photo}
    let(:photos) {fixtures.photos}
    let(:sizes) {fixtures.photo_sizes}
    let(:photo_details) {fixtures.photo_details}
    let(:interesting_photos) {fixtures.interesting_photos}


  describe "@defaults class instance variables" do
    before(:each) do
      @defaults = api.defaults.clone
    end

    after(:each) do
      api.defaults = @defaults
    end
    it "should contain expected keys" do
      api.defaults.keys.sort.should  == [:per_page,:license,:media,:extras,:tag_mode,:flickr_tag_modes].sort
    end

    it "should be able to set the values" do
      expected = "#{Random.srand}"
      api.defaults.keys.each do |k|
        api.defaults[k] = expected
        api.defaults[k].should == expected
      end
    end
  end
  
  describe "search" do
    let(:per_page) {'5'}
    let(:search_terms) {'iran'}
    let(:base_url) {'http://www.example.com/'}
    subject {
        flickr.photos.stubs(:search).returns(photos)
        api.photos({:per_page=>per_page,:search_terms => search_terms})
    }
    it "should return object of proper class" do
      subject.should be_instance_of(APP::PhotoSearch)
    end
    it "should return proper search_terms" do
      subject.search_terms.should == 'iran'
    end
  end

  describe "photos" do
    subject {
      flickr.photos.stubs(:getInfo).returns(photo)
      api.photo({:photo =>photo.id,:secret => photo.secret})
    }
      
    it "should return an object of the proper class" do
      subject.should be_an_instance_of(APP::Photo)
    end
    it "should return object with proper id" do
      subject.id.should == photo.id
    end
    it "should return object with proper secret" do
      subject.secret.should == photo.secret
    end
  end

  describe "photo_sizes" do
    let(:small_photo){APP::PhotoSize.new(sizes[0])}
    subject {
      flickr.photos.stubs(:getSizes).returns(sizes)
      api.photo_sizes(:photo => small_photo.id, :secret => small_photo.secret)
    }

    it "should return object of a proper class" do
      subject.should be_an_instance_of(APP::PhotoSizes)
    end
    it "should return object of proper id" do
      subject[0].id.should == small_photo.id
    end
    it "should return object with proper secret" do
      subject[0].secret.should == small_photo.secret
    end
    it "should return correct number of photo sizes" do
       subject.available_sizes.count.should == sizes.count
    end
  end

  describe "photo_details" do
      subject {
        flickr.photos.stubs(:getSizes).returns(sizes)
        flickr.photos.stubs(:getInfo).returns(photo)
         api.photo_details(:photo => photo.id,:secret => photo.secret)
      }
    it "should return an object of the proper class" do
      subject.should be_an_instance_of(APP::PhotoDetails)
    end
    it "should return proper class when called :sizes" do
      subject.sizes.should be_instance_of(APP::PhotoSizes)
    end
    it "should return a photo with proper id" do
      subject.id.should == photo["id"]
    end 
  end

  describe "interesting_photos" do
    let(:base_url) {'http:://www.example.com/'}
    let(:date){'2004-11-20'}
    subject {
      flickr.interestingness.stubs(:getList).returns(interesting_photos)
      api.interesting_photos({:date => date,:base_url => base_url})
    }

    it "should return object of proper class" do
      subject.should be_an_instance_of(APP::PhotoSearch)
    end
    it "should return proper date for photo" do
      subject.date.should == date
    end
  end

end