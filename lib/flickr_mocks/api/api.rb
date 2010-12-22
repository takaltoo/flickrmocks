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
      raise ArgumentError.new("Expecting a Hash argument.") unless params.is_a?(Hash)
      photos = Api.flickr_photos(params)
      PhotoSearch.new photos,Api.search_params(params)
    end

    def self.photo_details(params)
      raise ArgumentError.new("Expecting a Hash argument.") unless params.is_a?(Hash)
      photo = Api.flickr_photo(params)
      sizes = Api.flickr_photo_sizes(params)
      PhotoDetails.new(photo,sizes)
    end

    def self.photo(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      Photo.new Api.flickr_photo(params)
    end

    def self.photo_sizes(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      PhotoSizes.new Api.flickr_photo_sizes(params)
    end

    def self.interesting_photos(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      photos = Api.flickr_interestingness(params)
      PhotoSearch.new photos,Api.interesting_params(params)
    end

    def self.commons_institutions(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      institutions = Api.flickr_commons_institutions
      CommonsInstitutions.new institutions,Api.commons_institutions_params(params)
    end

  end
end