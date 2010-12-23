require 'spec_helper'

describe APP::Api::Flickr do
  let(:klass){APP::Api::Flickr}
  let(:fixtures){APP::Fixtures.instance}
  
  context "class methods" do
    specify {klass.should respond_to(:photos)}
    context "photos" do
      it "returns list of photos" do
        flickr.photos.stub(:search).and_return(fixtures.photos)
        klass.photos({}).should == fixtures.photos
      end
    end

    specify {klass.should respond_to(:photo)}
    context "photos" do
      it "returns photo" do
        flickr.photos.stub(:getInfo).and_return(fixtures.photo)
        klass.photo({}).should == fixtures.photo
      end
    end

    specify {klass.should respond_to(:photo_sizes)}
    context "photo_sizes" do
      it "returns list sizes for a photo" do
        flickr.photos.stub(:getSizes).and_return(fixtures.photo_sizes)
        klass.photo_sizes({}).should == fixtures.photo_sizes
      end
    end

    specify {klass.should respond_to(:interestingness)}
    context "interestingness" do
      it "returns list of interesting photos" do
        flickr.interestingness.stub(:getList).and_return(fixtures.interesting_photos)
        klass.interestingness({}).should == fixtures.interesting_photos
      end
    end
    
    specify {klass.should respond_to(:author)}
    context "author" do
      it "returns list of photos for an author" do
        flickr.photos.stub(:search).and_return(fixtures.author_photos)
        klass.author({}).should == fixtures.author_photos
      end
    end

    specify {klass.should respond_to(:commons_institutions)}
    it "retuns list of commons institutions" do
      flickr.commons.stub(:getInstitutions).and_return(fixtures.commons_institutions)
      klass.commons_institutions.should == fixtures.commons_institutions
    end
  end
end
