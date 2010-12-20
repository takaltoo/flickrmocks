require 'spec_helper'

describe APP::Stubs do
  let(:klass) {APP::Stubs}
  let(:fixtures) {APP::Fixtures.instance}
  let(:flickr_stubs){klass::Flickr}
  let(:api_stubs){klass::Api}
  let(:api){APP::Api}
  context "class methods" do
    context "Flickr Stubs" do

      specify{flickr_stubs.should respond_to(:all)}
      context "all" do
        before(:each) do
          flickr_stubs.all
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

        it "stubs flickr.commons.getInstitutions" do
          flickr.commons.getInstitutions.should == fixtures.commons_institutions
        end
      
      end

      specify {flickr_stubs.should respond_to(:search)}
      context "stub_search: stubs for flickr.photos.search" do
        before(:each) do
          flickr_stubs.search
        end
        it "raises error when no options provided" do
          expect {
            flickr.photos.search
          }.to raise_error(
            FlickRaw::FailedResponse,
            /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
          )
        end
        it "raises when non-Hash option provided" do
          expect {
            flickr.photos.search([])
          }.to raise_error(
            FlickRaw::FailedResponse,
            /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
          )
        end
        it "raises error when neither :photo nor :user_id given" do
          expect {
            flickr.photos.search(:per_page => '3', :license => '4' )
          }.to raise_error(
            FlickRaw::FailedResponse,
            /'flickr.photos.search' - Parameterless searches have been disabled. Please use flickr.photos.getRecent instead./
          )
        end
        it "returns default photos fixture when :tags option given with non-garbage value" do
          flickr.photos.search(:tags => "france").should == fixtures.photos
        end
        it "returns empty photos when :tags option given with garbage value" do
          flickr.photos.search(:tags => "garbage").should == fixtures.empty_photos
        end
        it "returns author photo fixture when :user_id option given with non-garbage option" do
          flickr.photos.search(:user_id => '23@393').should == fixtures.author_photos
        end
        it "returns empty photos when :user_id is garbage" do
          flickr.photos.search(:user_id => 'garbage').should == fixtures.empty_photos
        end
        it "returns :author_photos when both :tags and :author_id provided with non-garbage option" do
          flickr.photos.search(:user_id => '23@23', :tags => '23@23').should == fixtures.author_photos
        end
        it "returns empty_photos when :tags is garbage and :author_id is non-garbage" do
          flickr.photos.search(:author_id => '23@393', :tags => 'garbage').should == fixtures.empty_photos
        end
        it "returns empty_photos when :author_id is garbage and :tags is non-garbage" do
          flickr.photos.search(:user_id=> 'garbage', :tags => 'france').should == fixtures.empty_photos
        end
        it "returns :empty when both :author_id and :tags is garbage" do
          flickr.photos.search(:user_id=>'garbage',:tags => 'garbage').should == fixtures.empty_photos
        end
      end


      specify {flickr_stubs.should respond_to(:getInfo)}
      context "getInfo: which stubs flickr.photos.getInfo" do
        before(:each) do
          flickr_stubs.getInfo
        end
        it "returns photo details fixture when photo_id and secret given" do
          flickr.photos.getInfo(:secret => 'b5da82cd4e', :photo_id => '51028174').should == fixtures.photo_details
        end
        it "returns photo details fixture when  photo_id and no secret given" do
          flickr.photos.getInfo(:photo_id => '51028174').should == fixtures.photo_details
        end

        context "error conditions" do
          it "raises error when no arguments provided" do
            expect { flickr.photos.getInfo.should }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getInfo' - Photo not found/
            )
          end
          it "raises error when 'garbage' photo_id provided" do
            expect { flickr.photos.getInfo(:photo_id => 'garbage') }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getInfo' - Photo "garbage" not found \(invalid ID\)/
            )
          end
          it "raises error when 'garbage' photo_id provided" do
            expect {
              flickr.photos.getInfo(:photo_id => nil)
            }.to raise_error(FlickRaw::FailedResponse)
          end
          
          it "raises error when non-hash option provided" do
            expect { flickr.photos.getInfo([]).should }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getInfo' - Photo not found/
            )
          end
        end
      end

      specify {flickr_stubs.should respond_to(:getSizes)}
      context "stub_getSizes: which stubs flickr.photos.getSizes" do
        before(:each) do
          flickr_stubs.getSizes
        end
        it "returns photo sizes fixture when option given" do
          flickr.photos.getSizes(:secret => '3c4374b19e', :photo_id => "5102817422").should == fixtures.photo_sizes
        end
        context "error conditions" do
          it "raises error when no options given" do
            expect {
              flickr.photos.getSizes
            }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getSizes' - Photo not found/
            )
          end
          it "raises error when non-hash given" do
            expect {
              flickr.photos.getSizes []
            }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getSizes' - Photo not found/
            )
          end
          it "raises error when photo_id is garbage" do
            expect {
              flickr.photos.getSizes :photo_id => 'garbage'
            }.to raise_error(
              FlickRaw::FailedResponse,
              /'flickr.photos.getSizes' - Photo not found/
            )
          end
          it "raises an error when photo_id is nil" do
            expect {
              flickr.photos.getSizes :photo_id => nil
            }.to raise_error(FlickRaw::FailedResponse)
          end
        end
      end

      specify {flickr_stubs.should respond_to(:interestingness)}
      context "interestingness: stubs  flickr.interestingness.getList" do
        before(:each) do
          flickr_stubs.interestingness
        end
        it "returns interesting fixture when no option given" do
          flickr.interestingness.getList.should == fixtures.interesting_photos
        end
        it "returns interesting fixture with non-hash option argument" do
          flickr.interestingness.getList([]).should == fixtures.interesting_photos
        end
        it "returns interesting fixture if hash-option with :date key provided" do
          flickr.interestingness.getList(:tags => 'hello').should == fixtures.interesting_photos
        end
        it "raises error if invalid date provided" do
          expect {
            flickr.interestingness.getList(:date => 'garbage')
          }.to raise_error(
            FlickRaw::FailedResponse,
            /Not a valid date string/
          )
        end
        it "returns empty string if 2001-01-01 given" do
          flickr.interestingness.getList(:date => '2000-01-01').should == fixtures.empty_photos
        end
        it "returns photo details fixture when option given" do
          flickr.interestingness.getList(:date=> '2010-10-10').should == fixtures.interesting_photos
        end
      end

      specify {flickr_stubs.should respond_to(:commons_institutions)}
      context "commons_institutions" do
        before(:each) do
          flickr_stubs.commons_institutions
        end
        it "returns commons_institutions fixture" do
          flickr.commons.getInstitutions.should == fixtures.commons_institutions
        end
      end
    end

    context "Api stubs" do
      specify {api_stubs.should respond_to :photos}
      context "photos" do
        before(:each) do
          api_stubs.photos
        end
        context "owner_id provided" do
          it "returns object with same user when owner_id provided" do
            params = {:owner_id => '1'}
            api.photos(:owner_id => '1').should ==
              ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params(params))
          end
          it "returns object with same user when owner_id and tags provided" do
            params = {:owner_id => '1',:search_terms => 'iran'}
            api.photos(:owner_id => '1').should ==
              ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params({:owner_id => '1'}))
          end
          it "returns object with no entries when owner_id set to  'garbage'" do
            api.photos(:owner_id => 'garbage').should ==
              ::FlickrMocks::PhotoSearch.new(fixtures.empty_photos,api.search_params({:owner_id => 'garbage'}))
          end
        end
        context "search_terms provided" do
          it "returns object with different owner_id values when :search_terms provided" do
            params = {:search_terms => 'iran'}
            api.photos(params).should ==
              ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params(params))
          end
          it "returns object with no entries when :search_terms is set to 'garbage'" do
            params = {:search_terms => 'garbage'}
            api.photos(params).should ==
              ::FlickrMocks::PhotoSearch.new(fixtures.empty_photos,api.search_params(params))
          end
        end

        context "error conditions" do
          let(:subject){api}
          let(:method){:photos}
          it_behaves_like "object that expects single Hash argument"
        end

      end

      specify {api_stubs.should respond_to :photo_details}
      context "photo_details" do
        before(:each) do
          api_stubs.photo_details
        end
        it "returns expected object when proper :photo_id provided" do
          api.photo_details(:photo_id => '1234').should ==
            ::FlickrMocks::PhotoDetails.new(fixtures.photo_details,fixtures.photo_sizes)
        end

        context "error conditions" do
          let(:subject){api}
          let(:method){:photo_details}
          it_behaves_like "object that expects single Hash argument"
          
          it "raises FlickRaw::FailedResponse when :photo_id not supplied in Hash" do
            expect {
              api.photo_details({})
            }.to raise_error(FlickRaw::FailedResponse)
          end
          it "raises FlickRaw::FailedResponse when :photo_id is nil" do
            expect {
              api.photo_details({:photo_id => nil})
            }.to raise_error(FlickRaw::FailedResponse)
          end
          it "raises FlickRaw::FailedResponse when :photo_id is garbage" do
            expect {
              api.photo_details({:photo_id => 'garbage'})
            }.to raise_error(FlickRaw::FailedResponse)
          end
        end
      end

      specify {api_stubs.should respond_to :photo}
      context "photo" do
         context "error conditions" do
        end

      end
      
      specify {api_stubs.should respond_to :photo_sizes}
      context "photo_sizes" do

      end
      
      specify {api_stubs.should respond_to :interesting_photos}
      context "interesting_photos" do

      end
      
      specify {api_stubs.should respond_to :commons_institutions}
      context "commons_institutions" do
        
      end
      
    end


  end
end