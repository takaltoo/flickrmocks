require 'spec_helper'
require 'ruby-debug'
describe APP::Api do
  let(:klass) { APP::Api }

  let(:fixtures){APP::Fixtures.instance}
  let(:photo){fixtures.photo}
  let(:photos){fixtures.photos}
  let(:sizes){fixtures.photo_sizes}
  let(:photo_details){fixtures.photo_details}
  let(:interesting_photos){fixtures.interesting_photos}
  let(:commons_institutions){fixtures.commons_institutions}


  context "class instance variables" do
    context "@defaults" do
      before(:each) do
        @defaults = klass.defaults.clone
      end
      after(:each) do
        klass.defaults = @defaults
      end
      it "returns has with expected set of keys" do
        klass.defaults.keys.sort.should  == [:per_page,:license,:media,:extras,:tag_mode,:flickr_tag_modes].sort
      end
      it "returns object whose elements can be set similar to a hash" do
        expected = "#{Random.srand}"
        klass.defaults.keys.each do |k|
          klass.defaults[k] = expected
          klass.defaults[k].should == expected
        end
      end
    end
  end

  context "class methods" do
    let(:subject){klass}
    specify {klass.should respond_to(:photo)}
    context "photo" do
      it "returns expected Photo object" do
        flickr.photos.stub(:getInfo).and_return(photo)
        klass.photo({:photo =>photo.id,
                         :secret => photo.secret}).should == APP::Photo.new(photo)
      end
      context "arguments" do
        let(:method){:photo}
        it_behaves_like "object that expects single Hash argument"
      end
    end

    specify {klass.should respond_to(:photos)}
    context "photos" do
      it "returns expected PhotoSearch object" do
        flickr.photos.stub(:search).and_return(photos)
        klass.photos({:search_terms => 'iran'}).should ==
          APP::PhotoSearch.new(photos,{:search_terms => 'iran'})
      end
      it "raises error when non-hash argument provided" do
        expect {
          klass.photos([])
        }.to raise_error(ArgumentError)
      end
      context "arguments" do
        let(:method){:photos}
        it_behaves_like "object that expects single Hash argument"
      end
    end

    specify {klass.should respond_to(:photo_sizes)}
    context "photo_sizes" do
      it "returns expected PhotoSizes object" do
        expected = APP::PhotoSizes.new(sizes)
        flickr.photos.stub(:getSizes).and_return(sizes)
        klass.photo_sizes(:photo => expected.id,
                                :secret => expected.secret).should ==  expected
      end
      context "arguments" do
        let(:method){:photos}
        it_behaves_like "object that expects single Hash argument"
      end
    end
    
    specify {klass.should respond_to(:photo_details)}
    describe "photo_details" do
      it "returns expected PhotoDetails object" do
        flickr.photos.stub(:getSizes).and_return(sizes)
        flickr.photos.stub(:getInfo).and_return(photo)
        klass.photo_details(:photo => photo.id,
                                  :secret => photo.secret).should  == APP::PhotoDetails.new(photo,sizes)
      end
      context "arguments" do
        let(:method){:photo_details}
        it_behaves_like "object that expects single Hash argument"
      end
      
    end

    specify {klass.should respond_to(:interesting_photos)}
    describe "interesting_photos" do
      it "returns expected PhotoSearch object" do
        flickr.interestingness.stub(:getList).and_return(interesting_photos)
        klass.interesting_photos({:date => '2010-01-01'}).should ==
                  APP::PhotoSearch.new(interesting_photos,{:date => '2010-01-01'})
      end
      context "arguments" do
        let(:method){:interesting_photos}
        it_behaves_like "object that expects single Hash argument"
      end      
    end

    specify {klass.should respond_to(:commons_institutions)}
    describe "commons_institutions" do
      it "returns expected CommonsInstitutions object" do
        flickr.commons.stub(:getInstitutions).and_return(commons_institutions)
        klass.commons_institutions({}).should ==
          APP::CommonsInstitutions.new(commons_institutions)
      end
      context "arguments" do
        let(:method){:commons_institutions}
        it_behaves_like "object that expects single Hash argument"
      end
    end

  end
end
