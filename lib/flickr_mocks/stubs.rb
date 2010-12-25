module FlickrMocks
  # wrapper for methods that are used for Stubbing FlickRaw queries and Api calls that
  # access the Flickr API. These methods are useful for stubbing the Flickr API for
  # your Rspec 2.0 tests.
  module Stubs
    module Api
      # Stubs all the wrapper Api calls to Flickr
      def self.all
        [:photos,:photo_details,:photo,:photo_sizes,
          :interesting_photos,:commons_institutions].each do |method|
          self.send(method)
        end
      end


      # Stubs the call to Api.photos. The stub returns an object of class Flickr::PhotoSearch.
      # The stub's return value depends on the supplied options hash:
      #
      #   :search_terms => 'garbage' (returns empy list of photos)
      #   :owner_id => 'garbage' (returns empty list of photos)
      #   :owner_id => '<valid_id>' (returns list of photos that contain same author photos; valid_id is any string other than garbage)
      #   :search_terms => '<valid_tag>' (returns list of photos with different author photos (if :owner_id must be nil); valid_tag is any string other than 'garbage')
      #   :search_terms => nil and :owner_id => nil (raises FlickRaw::FailedResponse error)
      def self.photos
        lambda {::FlickrMocks::Api.stub(:photos) do |params|
            ::FlickrMocks::Stubs::Flickr.search
            case params
            when Hash then
              Models::PhotoSearch.new flickr.photos.search(::FlickrMocks::Api::Options.search(params)),params
            else
              raise ArgumentError
            end
        end}.call
      end

      # stubs the call to Api.photo_details.The stub returns an object of class Models::PhotoDetails. Its
      # state depends on the supplied options:
      #
      #   :photo_id or :id => 'garbage' (raises FlickRaw::FailedResponse error)
      #   :photo_id or :id => nil (raises FlickRaw::FailedResponse error)
      #   :photo_id or :id => <valid_id> (returns a photo fixture with detailed information; valid_id can be any string other than 'garbage' )
      def self.photo_details
        lambda {::FlickrMocks::Api.stub(:photo_details) do |params|
            ::FlickrMocks::Stubs::Flickr.getInfo
            ::FlickrMocks::Stubs::Flickr.getSizes
            case params
            when Hash then
              Models::PhotoDetails.new(flickr.photos.getInfo(::FlickrMocks::Api::Options.photo(params)),
                flickr.photos.getSizes(::FlickrMocks::Api::Options.photo(params)))
            else
              raise ArgumentError
            end
          end}.call
      end

      # stubs the call to Api.photo. The stub returns an object of class Models::Photo. Its
      # state depends on the supplied options:
      #
      #   :photo_id or :id => 'garbage' (raises Invaid ID error)
      #   :photo_id or :id => nil (raises invalid ID error)
      #   :photo_id or :id => <valid_id> (returns a photo fixture with detailed information; valid_id is any string other than 'garbage')
      def self.photo
        lambda{::FlickrMocks::Api.stub(:photo) do |params|
            ::FlickrMocks::Stubs::Flickr.getInfo
            case params
            when Hash then
              Models::Photo.new(::FlickrMocks::Api::Flickr.photo(params))
            else
              raise ArgumentError
            end
        end}.call
      end

      # stubs the call to Api.photo_sizes. The stub returns an object of class Models::PhotoSizes.
      # Its state depends on the supplied options:
      #
      #   :photo_id or :id => 'garbage' (raises FlickRaw::FailedResponse error)
      #   :photo_id or :id => nil (raises FlickRaw::FailedResponse error)
      #   :photo_id or :id => <valid_id> (returns list of photo sizes; valid_id is any string other than 'garbage')
      def self.photo_sizes  
         lambda {::FlickrMocks::Api.stub(:photo_sizes) do |params|
            ::FlickrMocks::Stubs::Flickr.getSizes
            case params
            when Hash then
              Models::PhotoSizes.new(flickr.photos.getSizes(::FlickrMocks::Api::Options.photo(params)))
            else
              raise ArgumentError
            end
          end}.call
      end

      # stubs the call to Api.interesting_photos. The stub returns an object of class
      # Models::PhotoSearch on the supplied options hash. The stub's return value depends on
      # the supplied option:
      # 
      #  :date => '2000-01-01' (returns empy list of photos)
      #  :date => 'garbage' (raises an error)
      #  :date => <valid_id> (returns interesting list of photos; date is any string other than 'garbage' and '2001-01-01')
      def self.interesting_photos
         lambda {::FlickrMocks::Api.stub(:interesting_photos) do |params|
            ::FlickrMocks::Stubs::Flickr.interestingness
            case params
            when Hash then
              Models::PhotoSearch.new(flickr.interestingness.getList(params),params)
            else
              raise ArgumentError
            end
          end}.call
      end

      # stubs the call to Api.commons_institutions.
      def self.commons_institutions
        lambda {::FlickrMocks::Api.stub(:commons_institutions) do |params|
            ::FlickrMocks::Stubs::Flickr.commons_institutions
            case params
            when Hash then
              CommonsInstitutions.new(::FlickrMocks::Api.flickr_commons_institutions,params)
            else
              raise ArgumentError
            end
          end}.call
      end

    end

    # stubs low level FlickRaw Api calls to Flickr
    module Flickr
      # Stubs the calls to the following Api
      #  flickr.photos.search
      #  flickr.photos.getInfo
      #  flickr.photos.getSizes
      #  flickr.interestingness.getList
      #  flickr.commons.getInstitutions
      def self.all
        [:search,:getInfo,:getSizes,:interestingness,:commons_institutions].each do |method|
          self.send(method)
        end
      end

      # Stubs the calls to flickr.photos.search. The stub's return value depends on
      # the supplied options hash:
      #
      #   :tags => 'garbage' (returns empy list of photos)
      #   :user_id => 'garbage' (returns empty list of photos)
      #   :user_id => '<valid_id>' (returns list of photos that contain same author photos)
      #   :tags => '<valid_tag>' (returns list of photos with different author photos; only if valid author id is not provided)
      def self.search
        fixtures = Fixtures.instance
        lambda { flickr.photos.stub(:search) do |params|
            if !params.is_a?(Hash)
              raise FlickRaw::FailedResponse.new('Parameterless searches have been disabled. Please use flickr.photos.getRecent instead.',
                'code','flickr.photos.search'
              )
            elsif(params[:tags] == 'garbage' || params[:user_id] == 'garbage')
              fixtures.empty_photos
            elsif(params[:tags] && params[:user_id])
              fixtures.author_photos
            elsif !params[:user_id].nil?
              fixtures.author_photos
            elsif !params[:tags].nil?
              fixtures.photos
            else
              raise FlickRaw::FailedResponse.new('Parameterless searches have been disabled. Please use flickr.photos.getRecent instead.',
                'code','flickr.photos.search'
              )
            end
          end
        }.call
      end

      # Stubs the calls to flickr.photos.getInfo. The stub's return value depends on
      # the supplied options hash:
      #
      #   :photo_id => 'garbage' (raises Invaid ID error)
      #   :photo_id => nil (raises invalid ID error)
      #   :photo_id => <valid_id> (returns a photo fixture with detailed information)
      def self.getInfo
        lambda {
          flickr.photos.stub(:getInfo) do |params|
            if !params.is_a?(Hash)
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code', 'flickr.photos.getInfo')
            elsif !params.has_key?(:photo_id) 
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code', 'flickr.photos.getInfo')
            elsif params[:photo_id] == 'garbage'
              raise FlickRaw::FailedResponse.new('Photo "%s" not found (invalid ID)' % params[:photo_id],
                'code','flickr.photos.getInfo')
            elsif params[:photo_id].nil?
              raise FlickRaw::FailedResponse.new('Photo "nil" not found (invalid ID)',
                'code','flickr.photos.getInfo')
            else
              Fixtures.instance.photo_details
            end
          end
        }.call
      end

      # stubs flickr.photos.getSizes. The stub's return value depends
      # on the supplied options hash:
      #
      #  :photo_id => nil (raises FlickRaw::FailedResponse error)
      #  :photo_id => 'garbage' (raises FlickRaw::FailedResponse error)
      #  :photo_id => '<valid_id>' (returns a list of photo sizes)
      def self.getSizes
        lambda {
          flickr.photos.stub(:getSizes) do |params|
            if !params.is_a?(Hash)
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code', 'flickr.photos.getSizes')
            elsif !params.has_key?(:photo_id)
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code', 'flickr.photos.getSizes')
            elsif params[:photo_id] == 'garbage'
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code','flickr.photos.getSizes')
            elsif params[:photo_id] == nil
              raise FlickRaw::FailedResponse.new('Photo not found',
                'code','flickr.photos.getSizes')
            else
              Fixtures.instance.photo_sizes
            end
          end
        }.call
      end

      # stubs flickr.interestingness.getList. The stub's return value depends
      # on the supplied options hash.
      #
      #  :date => '2000-01-01' (returns empy list of photos)
      #  :date => 'garbage' (raises an error)
      #  :date => <valid_id> (returns interesting list of photos)
      def self.interestingness
        lambda {
          flickr.interestingness.stub(:getList) do |params|
            if !params.is_a?(Hash)
              Fixtures.instance.interesting_photos
            elsif params[:date] == '2000-01-01'
              Fixtures.instance.empty_photos
            elsif params[:date] == 'garbage'
              raise FlickRaw::FailedResponse.new('Not a valid date string',
                'code','flickr.interestingness.getList'
              )
            else
              Fixtures.instance.interesting_photos
            end
          end
        }.call
      end

      # stubs the flickr.commons.getInstitutions. Stub returns a list of
      # commons institutions.
      def self.commons_institutions
        lambda {
          flickr.commons.stub(:getInstitutions) do
            Fixtures.instance.commons_institutions
          end
        }.call
      end
    end
  end
end









