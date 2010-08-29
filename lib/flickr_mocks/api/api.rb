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
      photos = self.flickr_photos(params)
      Photos.new photos,self.search_params(params)
    end

    def self.photo_details(params)
      photo = self.flickr_photo(params)
      sizes = self.flickr_photo_sizes(params)
      @this = @photo = PhotoDetails.new(photo,sizes)
    end

    def self.photo(params)
      Photo.new self.flickr_photo(params)
    end

    def self.photo_sizes(params)
      PhotoSizes.new self.flickr_photo_sizes(params)
    end

    def self.interesting_photos(params)
      photos = self.flickr_interestingness(params)
      Photos.new photos,self.interesting_params(params)
    end

  end
end