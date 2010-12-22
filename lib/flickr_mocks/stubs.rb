module FlickrMocks
  module Stubs
    module Api
      def self.all
        [:photos,:photo_details,:photo,:photo_sizes,
          :interesting_photos,:commons_institutions].each do |method|
          self.send(method)
        end
      end

      def self.photos
        lambda {::FlickrMocks::Api.stub(:photos) do |params|
            ::FlickrMocks::Stubs::Flickr.search
            case params
            when Hash then
              PhotoSearch.new flickr.photos.search(::FlickrMocks::Api.search_options(params)),::FlickrMocks::Api.search_params(params)
            else
              raise ArgumentError
            end
        end}.call
      end

      def self.photo_details
        lambda {::FlickrMocks::Api.stub(:photo_details) do |params|
            ::FlickrMocks::Stubs::Flickr.getInfo
            ::FlickrMocks::Stubs::Flickr.getSizes
            case params
            when Hash then
              PhotoDetails.new(flickr.photos.getInfo(::FlickrMocks::Api.photo_options(params)),
                flickr.photos.getSizes(::FlickrMocks::Api.photo_options(params)))
            else
              raise ArgumentError
            end
          end}.call
      end

      def self.photo
        lambda{::FlickrMocks::Api.stub(:photo) do |params|
            ::FlickrMocks::Stubs::Flickr.getInfo
            case params
            when Hash then
              Photo.new(::FlickrMocks::Api.flickr_photo(params))
            else
              raise ArgumentError
            end
        end}.call
      end

      def self.photo_sizes  
         lambda {::FlickrMocks::Api.stub(:photo_sizes) do |params|
            ::FlickrMocks::Stubs::Flickr.getSizes
            case params
            when Hash then
              PhotoSizes.new(flickr.photos.getSizes(::FlickrMocks::Api.photo_options(params)))
            else
              raise ArgumentError
            end
          end}.call
      end

      def self.interesting_photos
         lambda {::FlickrMocks::Api.stub(:interesting_photos) do |params|
            ::FlickrMocks::Stubs::Flickr.interestingness
            case params
            when Hash then
              PhotoSearch.new(flickr.interestingness.getList(params),
                ::FlickrMocks::Api.interesting_params(params))
            else
              raise ArgumentError
            end
          end}.call
      end

      def self.commons_institutions
        lambda {::FlickrMocks::Api.stub(:commons_institutions) do |params|
            ::FlickrMocks::Stubs::Flickr.commons_institutions
            case params
            when Hash then
              CommonsInstitutions.new(::FlickrMocks::Api.flickr_commons_institutions,
                ::FlickrMocks::Api.commons_institutions_params(params))
            else
              raise ArgumentError
            end
          end}.call
      end

    end


    module Flickr
      def self.all
        [:search,:getInfo,:getSizes,:interestingness,:commons_institutions].each do |method|
          self.send(method)
        end
      end


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
            elsif params.has_key?(:tags)
              fixtures.photos
            elsif params.has_key?(:user_id)
              fixtures.author_photos
            else
              raise FlickRaw::FailedResponse.new('Parameterless searches have been disabled. Please use flickr.photos.getRecent instead.',
                'code','flickr.photos.search'
              )
            end
          end
        }.call
      end

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
            elsif params[:photo_id] == nil
              raise FlickRaw::FailedResponse.new('Photo "nil" not found (invalid ID)',
                'code','flickr.photos.getInfo')
            else
              Fixtures.instance.photo_details
            end
          end
        }.call
      end

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









