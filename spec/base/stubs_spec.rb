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
        flickr.photos.search(:tags => 'france').should == fixtures.photos
      end
      it "stubs flickr.photos.getSizes" do
        flickr.photos.getSizes(:photo_id => '2121', :secret => '123abc').should == fixtures.photo_sizes
      end
      it "stubs flickr.photos.getInfo" do
        flickr.photos.getInfo(:photo_id => '2121', :secret => '123abc').should == fixtures.photo_details
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
      it "should raise error when no options provided" do
        expect {
          flickr.photos.search
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
        )
      end
      it "should raise error when non-hash option provided" do
        expect {
          flickr.photos.search([])
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
        )
      end
      it "should raise error  when neither :photo nor :user_id given" do
        expect {
          flickr.photos.search(:per_page => '3', :license => '4' )
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
        )
      end
      it "should return default photos fixture when :tags option given with non-garbage value" do
        flickr.photos.search(:tags => "france").should == fixtures.photos
      end
      it "should return empty photos when :tags option given with garbage value" do
        flickr.photos.search(:tags => "garbage").should == fixtures.empty_photos
      end
      it "should return author photo fixture when :user_id option given with non-garbage option" do
        flickr.photos.search(:user_id => '23@393').should == fixtures.author_photos
      end
      it "should return empty photos when :user_id option given with garbage" do
        flickr.photos.search(:user_id => 'garbage').should == fixtures.empty_photos
      end
      it "should return :author_photos when both :tags and :author_id provided with non-garbage option" do
        flickr.photos.search(:user_id => '23@23', :tags => '23@23').should == fixtures.author_photos
      end
      it "should return empty_photos when :tags is garbage and :author_id is non-garbage" do
        flickr.photos.search(:author_id => '23@393', :tags => 'garbage').should == fixtures.empty_photos
      end
      it "should return empty_photos when :author_id is garbage and :tags is non-garbage" do
        flickr.photos.search(:user_id=> 'garbage', :tags => 'france').should == fixtures.empty_photos
      end
      it "should return :empty when both :author_id and :tags is garbage" do
        flickr.photos.search(:user_id=>'garbage',:tags => 'garbage').should == fixtures.empty_photos
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
      it "should raise error when no option given" do
        expect { flickr.photos.getInfo.should }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getInfo' - Photo not found/
        )
      end
      it "should raise error when garbage id given" do
        expect { flickr.photos.getInfo(:photo_id => 'garbage').should }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getInfo' - Photo "garbage" not found \(invalid ID\)/
        )
      end
      it "should raise error when non-hash option provided" do
        expect { flickr.photos.getInfo([]).should }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getInfo' - Photo not found/
        )
      end
      it "should return photo details fixture when option given" do
        flickr.photos.getInfo(:secret => 'b5da82cd4e', :photo_id => '51028174').should == fixtures.photo_details
      end
    end
  end

  context "stub_getSizes" do
    it "should respond to method" do
      klass.should respond_to(:stub_getSizes)
    end
    context "expected stub responses" do
      before(:each) do
          klass.stub_getSizes
      end
      it "should raise error when no options given" do
        expect {
          flickr.photos.getSizes
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getSizes' - Photo not found/
        )
      end
      it "should raise error when non-hash given" do
        expect {
          flickr.photos.getSizes []
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getSizes' - Photo not found/
        )
      end
      it "should raise error when garbage given as photo_id" do
        expect {
          flickr.photos.getSizes :photo_id => 'garbage'
        }.to raise_error(
          FlickRaw::FailedResponse,
          /'flickr.photos.getSizes' - Photo not found/
        )
      end
      it "should return photo sizes fixture when option given" do
        flickr.photos.getSizes(:secret => '3c4374b19e', :photo_id => "5102817422").should == fixtures.photo_sizes
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
      it "should return interesting fixture when no option given" do
        flickr.interestingness.getList.should == fixtures.interesting_photos
      end
      it "should return interesting fixture if non has option given" do
        flickr.interestingness.getList([]).should == fixtures.interesting_photos
      end
      it "should return interseting fixture if hash provided without :date key" do
        flickr.interestingness.getList(:tags => 'hello').should == fixtures.interesting_photos
      end
      it "should raise error if invalid date provided" do
        expect {
          flickr.interestingness.getList(:date => 'garbage')
        }.to raise_error(
          FlickRaw::FailedResponse,
          /Not a valid date string/
        )
      end
      it "should return empty string if 2001-01-01 given" do
        flickr.interestingness.getList(:date => '2000-01-01').should == fixtures.empty_photos
      end
      it "should return photo details fixture when option given" do
        flickr.interestingness.getList(:date=> '2010-10-10').should == fixtures.interesting_photos
      end
    end
  end

end