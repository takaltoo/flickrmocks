module FlickrMocks
  
  # Contains wrappers for performing queries against the Flickr API's. Uses the
  # FlickRaw gem to perform the queries. Query results are encapsulated in Ruby
  # classes for enhanced usability.
  #
  # Before calling the API methods you must initialize FlickRaw with your api_key:
  #
  #   FlickRaw.api_key = your_flickr_api_key
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

    # Used to search for photos that match the user provided parameters.
    # A sample search that returns up to 4,000 photos that are tagged with the keyword 'france' is
    # provided below:
    #  Api.photos(:search_terms => 'france') 
    # This method accepts an options hash that contains the fields:
    #   :search_terms : string with comma separated list of terms 'france,lyon'
    #   :owner_id : pptional string containing the id for the owner of the photo.
    #   :per_page : optional string containing the maximum number of photos returned in a single page. The default value is '200'
    #   :page : optional string containing the page for search results to be returned. The default is '1'
    #   :tag_mode : optionsl string containing either 'any' or 'all'. Affects the interpretation of the search terms to the FlickRaw API.
    def self.photos(params)
      raise ArgumentError.new("Expecting a Hash argument.") unless params.is_a?(Hash)
      photos = Api::Flickr.photos(params)
      PhotoSearch.new photos,Api.search_params(params)
    end

    # Used to return detailed information regarding a user specified photo. The method
    # returns a PhotoDetails object that encapsulates the retrieved data into an easy-to-use
    # Ruby class. A sample search that returns detailed information is provided below:
    #  Api.photo_details(:photo_id => '1234'
    # This method accepts an options hash with the fields:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
    def self.photo_details(params)
      raise ArgumentError.new("Expecting a Hash argument.") unless params.is_a?(Hash)
      photo = Api::Flickr.photo(params)
      sizes = Api::Flickr.photo_sizes(params)
      PhotoDetails.new(photo,sizes)
    end

    # Used to retrieve basic information regarding a single photo. This method returns a Photo
    # object that encapsulates the retrieved data into an easy-to-use Ruby class.
    # A sample search is provided below:
    #  Api.photo(:photo_id => '1234')
    # This method accepts an options hash with the fields:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
    def self.photo(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      Photo.new Api::Flickr.photo(params)
    end

    # Used to retrieve the available sizes for a given photo. This methods returns a PhotoSize
    # object that encapsulates the retrieved data into an easy-to-use Ruby class.
    # A sample search is provided below:
    #  Api.photo_sizes(:photo_id => '1234')
    # This method accepts an options hash with the fields:
    #   :photo_id : required string that contains the id for the photo
    #   :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
    def self.photo_sizes(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      PhotoSizes.new Api::Flickr.photo_sizes(params)
    end

    # Used to retrieve a list of interesting photos for a given date. This method returns a
    # PhotoSearch object that encapsulates the retrieved data into an easy-to-use Ruby class.
    # A sample search is provided below:
    #  Api.interesting_photos(:date => '2000-01-01'
    # This methods accepts an options hash with the fields:
    #  :date : string with date in the format yyyy-mm-dd
    #  :per_page : optional string containing the maximum number of photos returned in a single page. The default value is '200'
    #  :page : optional string containing the page for search results to be returned. The default is '1'
    def self.interesting_photos(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      photos = Api::Flickr.interestingness(params)
      PhotoSearch.new photos,Api.interesting_params(params)
    end

    # Used to retrieve a list of commons institutions. This method returns a CommonsInstitutions
    # object that encapsulates the retrieved data into an easy-to-use Ruby class.
    # a sample search is provided below:
    #  Api.commons_institutions({})
    # The method accepts an options hash with the fields:
    #
    def self.commons_institutions(params)
      raise ArgumentError.new("Expecting a Hash argument") unless params.is_a?(Hash)
      institutions = Api::Flickr.commons_institutions
      CommonsInstitutions.new institutions,Api.commons_institutions_params(params)
    end

  end
end