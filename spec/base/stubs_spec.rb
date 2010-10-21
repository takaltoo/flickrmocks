require 'spec_helper'

describe APP::Stubs do
  let(:klass) {APP::Stubs}
  let(:fixtures) {APP::Fixtures.new}

  context "stub_flickr" do
    it "should respond to method" do
      klass.should respond_to(:stub_flickr)
    end

    context "flickr search methods" do
      before(:each) do
        klass.stub_flickr
      end
      it "stubs flickr.photos.search" do
        flickr.photos.search.should == fixtures.photos
      end
      it "stubs flickr.photos.getSizes" do
        flickr.photos.getSizes.should == fixtures.photo_sizes
      end
      it "stubs flickr.photos.getInfo" do
        flickr.photos.getInfo.should == fixtures.photo_details
      end
      it "stubs flickr.interestingness.getList" do
        flickr.interestingness.getList.should == fixtures.interesting_photos
      end
    end
  end

  context "stub_search" do
    it "should respond to method" do
      klass.should respond_to(:stub_search)
    end
    context "stub flickr.photos.search" do
      before(:each) do
        klass.stub_search
      end
      it "should return default photos fixture when no options given" do
        flickr.photos.search.should == fixtures.photos
      end
      it "should return default photos fixture when non-hash option given" do
        flickr.photos.search([]).should == fixtures.photos
      end
      it "should return default photos fixture when :tags option given" do
        flickr.photos.search(:tags => "france").should == fixtures.photos
      end
      it "should return author photo fixture when :user_id option given" do
        flickr.photos.search(:user_id => '23@393').should == fixtures.author_photos
      end
      it "should return default fixture when neither :photo nor :user_id given" do
        flickr.photos.search(:per_page => '3', :license => '4' ).should == fixtures.photos
      end
    end
  end

  context "stub_getInfo" do
    it "should respond to method" do
      klass.should respond_to(:stub_getInfo)
    end
    context "stub flickr.photos.getInfo" do
      before(:each) do
        klass.stub_getInfo
      end
      it "should return photo details fixture when no option given" do
        flickr.photos.getInfo.should == fixtures.photo_details
      end
      it "should return photo details fixture when option given" do
        flickr.photos.getInfo(:secret => '2321afdae', :photo_id => '2322').should == fixtures.photo_details
      end
    end
  end

  context "stub_getSizes" do
    it "should respond to method" do
      klass.should respond_to(:stub_getSizes)
    end
    context "stub flickr.photos.getInfo" do
      before(:each) do
        klass.stub_getSizes
      end
      it "should return photo sizes fixture when no option given" do
        flickr.photos.getSizes.should == fixtures.photo_sizes
      end
      it "should return photo details fixture when option given" do
        flickr.photos.getSizes(:secret => '2321afdae', :photo_id => '2322').should == fixtures.photo_sizes
      end
    end
  end

  context "stub_interestingness" do
    it "should respond to method" do
      klass.should respond_to(:stub_interestingness)
    end
    context "stub flickr.interestingness" do
      before(:each) do
        klass.stub_interestingness
      end
      it "should return photo sizes fixture when no option given" do
        flickr.interestingness.getList.should == fixtures.interesting_photos
      end
      it "should return photo details fixture when option given" do
        flickr.interestingness.getList(:date=> '2010-10-10').should == fixtures.interesting_photos
      end
    end
  end

end