require 'spec_helper'

describe APP::Api do
  let(:klass){APP::Api}
  let(:fixtures){APP::Fixtures.instance}
  
  context "class methods" do
    specify {klass.should respond_to(:flickr_photos)}
    context "flickr_photos" do
      it "returns list of photos" do
        flickr.photos.stub(:search).and_return(fixtures.photos)
        klass.flickr_photos({}).should == fixtures.photos
      end
    end

    specify {klass.should respond_to(:flickr_photo)}
    context "flickr_photos" do
      it "returns photo" do
        flickr.photos.stub(:getInfo).and_return(fixtures.photo)
        klass.flickr_photo({}).should == fixtures.photo
      end
    end

    specify {klass.should respond_to(:flickr_photo_sizes)}
    context "flickr_photo_sizes" do
      it "returns list sizes for a photo" do
        flickr.photos.stub(:getSizes).and_return(fixtures.photo_sizes)
        klass.flickr_photo_sizes({}).should == fixtures.photo_sizes
      end
    end

    specify {klass.should respond_to(:flickr_interestingness)}
    context "flickr_interestingness" do
      it "returns list of interesting photos" do
        flickr.interestingness.stub(:getList).and_return(fixtures.interesting_photos)
        klass.flickr_interestingness({}).should == fixtures.interesting_photos
      end
    end
    
    specify {klass.should respond_to(:flickr_author)}
    context "flickr_author" do
      it "returns list of photos for an author" do
        flickr.photos.stub(:search).and_return(fixtures.author_photos)
        klass.flickr_author({}).should == fixtures.author_photos
      end
    end

    specify {klass.should respond_to(:flickr_commons_institutions)}
    it "retuns list of commons institutions" do
      flickr.commons.stub(:getInstitutions).and_return(fixtures.commons_institutions)
      klass.flickr_commons_institutions.should == fixtures.commons_institutions
    end
  end
end
