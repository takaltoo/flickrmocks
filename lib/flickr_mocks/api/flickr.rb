module FlickrMocks
  class Api
    # wrapper for flickr.photos.search Flickr API call. Recognized options include:
    #  :search_terms : string with comma separated list of terms 'france,lyon'
    #  :owner_id : pptional string containing the id for the owner of the photo.
    #  :per_page : optional string containing the maximum number of photos returned in a single page. The default value is '200'
    #  :page : optional string containing the page for search results to be returned. The default is '1'
    #  :tag_mode : optionsl string containing either 'any' or 'all'. Affects the interpretation of the search terms to the FlickRaw API.
    def self.flickr_photos(params)   
      flickr.photos.search self.search_options(params)
    end

    # wrapper for flickr.photos.getInfo Flickr API call. Recognized options include:
    #  :photo_id : required string that contains the id for the photo
    #  :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
    def self.flickr_photo(params)  
      flickr.photos.getInfo self.photo_options(params)
    end

    # wrapper for flickr.photos-getSizes Flickr API call. Recognized options include:
    #  :photo_id : required string that contains the id for the photo
    #  :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
    def self.flickr_photo_sizes(params)  
      flickr.photos.getSizes self.photo_options(params)
    end

    # wrapper for flickr.interestingness.getList Flickr API call. Recognized options
    # include:
    #   :date : string containing date of format 'YYYY-MM-DD'
    #   :per_page : optional string containing maximum number of items per page
    #   :page : optional string containing the page to retrieve for the query
    def self.flickr_interestingness(params) 
      flickr.interestingness.getList self.interesting_options(params)
    end

    # wrapper for flickr.photos-search Flickr API call. Options can be supplied
    # via a hash:
    #  :owner_id : string containing owner for the photo. This gets mapped to :user_id
    #  :per_page : optional string containing maximum number of items per page
    #  :page : optional string containing the page to retrieve for the query
    def self.flickr_author(params) 
      flickr.photos.search self.author_options(params)
    end

    # wrapper for flickr.commons.getInstitutions Flickr API call.
    def self.flickr_commons_institutions 
      flickr.commons.getInstitutions
    end
  end
end