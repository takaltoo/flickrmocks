module FlickrMocks
  module Stubs

    def self.stub_flickr
      [:stub_search,:stub_getInfo,:stub_getSizes,:stub_interestingness].each do |method|
        self.send(method)
      end
    end


    def self.stub_search
      fixtures = Fixtures.new
      Proc.new { flickr.photos.stub(:search) do |params|
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

    def self.stub_getInfo
      Proc.new { 
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
          else
            Fixtures.new.photo_details
          end
        end
      }.call
    end

    def self.stub_getSizes
      Proc.new {
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
          else
            Fixtures.new.photo_sizes
          end
        end
      }.call
    end

    def self.stub_interestingness
      Proc.new { 
        flickr.interestingness.stub(:getList) do |params|
          if !params.is_a?(Hash)
            Fixtures.new.interesting_photos
          elsif !params.has_key?(:date)
            Fixtures.new.interesting_photos
          elsif params[:date] == 'garbage'
            raise FlickRaw::FailedResponse.new('Not a valid date string',
            'code','flickr.interestingness.getList'
            )
          elsif params[:date] == '2000-01-01'
            Fixtures.new.empty_photos
          else
            Fixtures.new.interesting_photos
          end
        end
      }.call
    end

  end
end









