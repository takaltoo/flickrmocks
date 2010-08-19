module FlickrMocks

  class Api
    # Not required for testing, simple wrappers for flickr* methods
    def self.flickr_photos(params)
      flickr.photos.search self.search_options(params)
    end

    def self.flickr_photo(params)
      flickr.photos.getInfo self.photo_options(params)
    end

    def self.flickr_photo_sizes(params)
      flickr.photos.getSizes self.photo_options(params)
    end

    def self.flickr_interestingness(params)
      flickr.interestingness.getList self.interesting_options(params)
    end
  end
end
  

