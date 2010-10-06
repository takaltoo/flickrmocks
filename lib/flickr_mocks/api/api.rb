module FlickrMocks

  class Api
    @defaults = {
      :per_page => '200',
      :license => '4,5,6,7',
      :media => 'photos',
      :extras => 'license',
      :tag_mode => 'any',
      :flickr_tag_modes => ['any','all']
    }
  
    class << self
      attr_accessor :defaults
    end

    def self.photos(params)
      photos = Api.flickr_photos(params)
      PhotoSearch.new photos,Api.search_params(params)
    end

    def self.photo_details(params)
      photo = Api.flickr_photo(params)
      sizes = Api.flickr_photo_sizes(params)
      @this = @photo = PhotoDetails.new(photo,sizes)
    end

    def self.photo(params)
      Photo.new Api.flickr_photo(params)
    end

    def self.photo_sizes(params)
      PhotoSizes.new Api.flickr_photo_sizes(params)
    end

    def self.interesting_photos(params)
      photos = Api.flickr_interestingness(params)
      PhotoSearch.new photos,Api.interesting_params(params)
    end

  end
end