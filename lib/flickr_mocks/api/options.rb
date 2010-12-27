module FlickrMocks
  class Api
    # encapsulates methods that extract options from user-specified hash. Module is
    # used internally.
    module Options
      # returns parameter hash required for a flickr photo search. Sample usage:
      #
      #   self.search(:search_terms => 'iran', :tag_mode => 'any')
      #
      # Accepted options include:
      #  :search_terms : comma string containing the flickr search tags. Sample
      #                   string 'lyon,france"
      #  :owner_id : id for the photo. (either :owner_id or :search_terms
      #               must be specified
      #  :per_page : optional string containing the maximum number of items to
      #               return for a given page
      #  :page : optional string containing page number for the results. When
      #           page number is <= 0, it returns 1.
      #  :tag_mode : optional string containing how the tags for :search_terms
      #               should be interpreted. Can be either 'any' or 'all'
      def self.search(params)
        return {
          :tags => Api::Sanitize.tags(params[:search_terms]),
          :user_id =>  params[:owner_id],
          :per_page =>  Api::Sanitize.per_page_hash(params),
          :page =>  Api::Sanitize.page_hash(params),
          :license => Api.default(:license),
          :media => Api.default(:media),
          :extras => Api.default(:extras),
          :tag_mode => Api::Sanitize.tag_mode_hash(params)
        }
      end

      
      # returns parameter hash that is supplied for a interesting photo search.
      # Sample usage:
      #
      #   self.interesting(:date => '2010-10-10')
      #
      # Accepted options include:
      #  :date : string of format 'YYYY-MM-DD'. Photos of this date are retrieved.
      #           If none supplied, yesterday's date is used.
      #  :per_page : optional string containing the maximum number of items to
      #               return for a given page
      #  :page : optional string containing page number for the results. When page
      #           number is <= 0, it returns 1.
      #
      def self.interesting(params)
        return {
          :date => Api::Sanitize.date_hash(params),
          :per_page => Api::Sanitize.per_page_hash(params),
          :page =>  Api::Sanitize.page_hash(params),
          :extras => Api.default(:extras)
        }
      end

      # returns parameter hash for a single photo. Sample usage:
      #
      #  self.photo(:photo_id => '123')
      #
      # Accepted options include:
      #  :photo_id : string containing photo_id of the photo.
      #  :id : string containing photo id of the photo. It is an alias for :photo_id.
      #         If both are present :photo_id takes precedance.
      #  :secret : optional string containing the secret for the photo. If supplied
      #             the query is slightly faster.
      #  :photo_secret : optional string containing the secret for the photo. It
      #                   is an alias for :secret. If both supplied, :secret takes precedance.
      def self.photo(params)
        {
          :photo_id => params[:photo_id] || params[:id] || nil,
          :secret => params[:photo_secret] || params[:secret] || nil
        }
      end

      # returns parameter hash used for searching for photos of a given author.
      # Sample usage:
      #
      #   self.search(:owner_id => '1234')
      #
      # Accepted options include:
      #  :owner_id : id for the photo. (either :owner_id or :search_terms must be specified
      #  :per_page : optional string containing the maximum number of items to return
      #               for a given page
      #  :page : optional string containing page number for the results. When
      #           page number is <= 0, it returns 1.
      def self.author(params)
        options = Api::Options.search(params)
        options.delete :tags
        options
      end
    end
  end

end
