module FlickrMocks  
  # Wrappers for performing queries against the Flickr API's. Uses the
  # FlickRaw gem to perform the queries. Query results are encapsulated in easy-to-use
  # Ruby classes.
  #
  # Before calling the API methods you must initialize FlickRaw with your api_key:
  #
  #   FlickRaw.api_key = your_flickr_api_key
  class Api
    @defaults = {
      :page => '1',
      :per_page => '200',
      :license => '4,5,6,7',
      :media => 'photos',
      :extras => 'license',
      :max_entries => '4000',
      :tag_mode => 'any',
      :possible_tag_modes => ['any','all'],
      :possible_sizes => [:square, :thumbnail, :small, :medium, :medium_640, :large, :original],
      :usable_licenses => [4,5,6,7]
    }

    class << self
      attr_accessor :defaults
    end

    # returns the default value stored in the class instance variable @defaults hash.
    def self.default(value)
      Api.defaults[value.to_sym]
    end

    # Searches for photos that match the user provided parameters.
    # Sample usage:
    #  Api.photos(:search_terms => 'france') 
    # Options hash accepts:
    #   :search_terms : string with comma separated list of terms 'france,lyon'
    #   :owner_id : optional string containing the id for the owner of the photo.
    #   :per_page : optional string containing the maximum number of photos
    #                returned in a single page. The default value is '200'
    #   :page : optional string containing the page for search results to be
    #            returned. The default is '1'
    #   :tag_mode : optionsl string containing either 'any' or 'all'. Affects the
    #                interpretation of the search terms to the FlickRaw API.
    def self.photos(options)
      raise ArgumentError.new("Expecting a Hash argument.") unless options.is_a?(Hash)
      photos = Api::Flickr.photos(options)
      Models::PhotoSearch.new photos,options
    end

    # Retrieves detailed information for a photo. A PhotoDetails object that encapsulates
    # the retrieved data into an easy-to-use Ruby class is returned. Sample usage:
    #  Api.photo_details(:photo_id => '1234'
    # Options hash accepts:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo.
    #               When provided query is slightly faster
    def self.photo_details(options)
      raise ArgumentError.new("Expecting a Hash argument.") unless options.is_a?(Hash)
      photo = Api::Flickr.photo(options)
      sizes = Api::Flickr.photo_sizes(options)
      Models::PhotoDetails.new(photo,sizes)
    end

    # Retrieve basic information for a photo. Returns object of class Photo.
    # Sample usage:
    #  Api.photo(:photo_id => '1234')
    # Options hash accepts:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo.
    #               When provided query is slightly faster
    def self.photo(options)
      raise ArgumentError.new("Expecting a Hash argument") unless options.is_a?(Hash)
      Models::Photo.new Api::Flickr.photo(options)
    end

    # Retrieves available sizes for a given photo. Returns object of class PhotoSize.
    # Sample usage:
    #  Api.photo_sizes(:photo_id => '1234')
    # Options hash accepts:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo.
    #               When provided query is slightly faster
    def self.photo_sizes(options)
      raise ArgumentError.new("Expecting a Hash argument") unless options.is_a?(Hash)
      Models::PhotoSizes.new Api::Flickr.photo_sizes(options)
    end

    # Retrieves interesting photos for a given date. Returns object of class PhotoSearch.
    # Sample usage:
    #  Api.interesting_photos(:date => '2000-01-01'
    # Options hash accepts:
    #  :date : string with date in the format yyyy-mm-dd
    #  :per_page : optional string containing the maximum number of photos
    #               returned in a single page. The default value is '200'
    #  :page : optional string containing the page for search results to be
    #           returned. The default is '1'
    def self.interesting_photos(options)
      raise ArgumentError.new("Expecting a Hash argument") unless options.is_a?(Hash)
      photos = Api::Flickr.interestingness(options)
      Models::PhotoSearch.new photos,options
    end

    # Retrieves list of commons institutions. Returns object of class CommonsInstitutions.
    # Sample usage:
    #  Api.commons_institutions({})
    # Options hash accepts:
    #  :per_page : optional string containing the maximum number of photos returned
    #               in a single page. The default value is '200'
    #  :page : optional string containing the page for search results to be returned.
    #           The default is '1'
    def self.commons_institutions(options)
      raise ArgumentError.new("Expecting a Hash argument") unless options.is_a?(Hash)
      institutions = Api::Flickr.commons_institutions
      Models::CommonsInstitutions.new institutions,options
    end
  end
end