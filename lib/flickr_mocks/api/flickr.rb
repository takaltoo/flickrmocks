module FlickrMocks
  class Api
    # Wrapper methods for accessing Flickr Api. Module is used internally.
    module Flickr
      # Wrapper for flickr.photos.search Flickr API call.  Sample usage:
      #
      #   self.photos(:search_terms => 'france')
      #
      # Options hash accepts:
      #  :search_terms : string with comma separated list of terms 'france,lyon'
      #  :owner_id : pptional string containing the id for the owner of the photo.
      #  :per_page : optional string containing the maximum number of photos returned in a single page. The default value is '200'
      #  :page : optional string containing the page for search results to be returned. The default is '1'
      #  :tag_mode : optionsl string containing either 'any' or 'all'. Affects the interpretation of the search terms to the FlickRaw API.
      def self.photos(options)
        flickr.photos.search Api::Options.search(options)
      end

      # Wrapper for flickr.photos.getInfo Flickr API call.  Sample usage:
      #
      #   self.photo(:photo_id => '123')
      #
      # Options hash accepts:
      #  :photo_id : required string that contains the id for the photo
      #  :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
      def self.photo(options)
        flickr.photos.getInfo Api::Options.photo(options)
      end

      # Wrapper for flickr.photos-getSizes Flickr API call. Sample usage:
      #
      #   self.photo_sizes(:photo_id => '1', :secret => 'abcdef')
      #
      # Options hash accepts:
      #  :photo_id : required string that contains the id for the photo
      #  :secret  : optional string that contains the flickr secret for photo. When provided query is slightly faster
      def self.photo_sizes(options)
        flickr.photos.getSizes Api::Options.photo(options)
      end

      # Wrapper for flickr.interestingness.getList Flickr API call. Sample usage:
      #
      #   self.interestingness(:dage => '2010-10-10')
      #
      # Options hash accepts:
      #   :date : string containing date of format 'YYYY-MM-DD'
      #   :per_page : optional string containing maximum number of items per page
      #   :page : optional string containing the page to retrieve for the query
      def self.interestingness(options)
        flickr.interestingness.getList Api::Options.interesting(options)
      end

      # Wrapper for flickr.photos-search Flickr API call. Sample usage:
      #
      #   self.author(:owner_id => '20')
      #
      # Options hash accepts:
      #  :owner_id : string containing owner for the photo. This gets mapped to :user_id
      #  :per_page : optional string containing maximum number of items per page
      #  :page : optional string containing the page to retrieve for the query
      def self.author(options)
        flickr.photos.search Api::Options.author(options)
      end

      # wrapper for flickr.commons.getInstitutions Flickr API call. Sample usage:
      #
      #   self.commons_institutions
      #
      # Options hash accepts:
      #  :per_page : optional string containing maximum number of items per page
      #  :page : optional string containing the page to retrieve for the query
      def self.commons_institutions
        flickr.commons.getInstitutions
      end
    end
  end
end