require 'spec_helper'

describe APP::Stubs do
  let(:klass) {APP::Stubs}
  let(:fixtures) {APP::Fixtures.instance}
  let(:flickr_stubs){klass::Flickr}
  let(:api_stubs){klass::Api}
  let(:api){APP::Api}
  let(:models){APP::Models}
  
  context "class methods" do
    context "Flickr" do
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
        it "returns empty string if 2000-01-01 given" do
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

    context "Api" do
      specify{api_stubs.should respond_to(:all)}
      context "all" do
        before(:each) do
          api_stubs.all
        end
        it_behaves_like "stub for Api.photo"
        it_behaves_like "stub for Api.photos"
        it_behaves_like "stub for Api.photo_details"
        it_behaves_like "stub for Api.photo_sizes"
#        it_behaves_like "stub for Api.interesting_photos"
        it_behaves_like "stub for Api.commons_institutions"
      end

      specify {api_stubs.should respond_to :photos}
      context "photos" do
        before(:each) do
          api_stubs.photos
        end
        it_behaves_like "stub for Api.photos"
      end

      specify {api_stubs.should respond_to :photo_details}
      context "photo_details" do
        before(:each) do
          api_stubs.photo_details
        end
        it_behaves_like "stub for Api.photo_details"
      end

      specify {api_stubs.should respond_to :photo}
      context "photo" do
        before(:each) do
          api_stubs.photo
        end
        it_behaves_like "stub for Api.photo"
      end
      
      specify {api_stubs.should respond_to :photo_sizes}
      context "photo_sizes" do
        before(:each) do
          api_stubs.photo_sizes
        end
        it_behaves_like "stub for Api.photo_sizes"
      end
      
      specify {api_stubs.should respond_to :interesting_photos}
      context "interesting_photos" do
        before(:each) do
          api_stubs.interesting_photos
        end
        it_behaves_like "stub for Api.interesting_photos"
      end
      
      specify {api_stubs.should respond_to :commons_institutions}
      context "commons_institutions" do
        before(:each) do
          api_stubs.commons_institutions
        end
        it_behaves_like "stub for Api.commons_institutions"
      end
    end   
  end

end