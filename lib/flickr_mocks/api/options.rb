module FlickrMocks
  class Api
    # encapsulates methods that extract options from user-specified hash
    module Options
      # returns parameter hash for searching for flickr photos based on tags or owner
      def self.search(params)
        return {
          :tags => Api::Sanitize.tags(params[:search_terms]),
          :user_id =>  params[:owner_id],
          :per_page =>  Api::Sanitize.per_page(params),
          :page =>  Api::Sanitize.page(params),
          :license => Api.default(:license),
          :media => Api.default(:media),
          :extras => Api.default(:extras),
          :tag_mode => Api::Sanitize.tag_mode(params)
        }
      end

      # returns parameter hash for searching for interesting flickr photos
      def self.interesting(params)
        return {
          :date => Api::Sanitize.date(params),
          :per_page => Api::Sanitize.per_page(params),
          :page =>  Api::Sanitize.page(params),
          :extras => Api.default(:extras)
        }
      end

      # returns parameter hash for a basic photo search
      def self.photo(params)
        {
          :photo_id => params[:photo_id] || params[:id] || nil,
          :secret => params[:photo_secret] || params[:secret] || nil
        }
      end

      # returns parameter hash for searching for photos of a given author_id
      def self.author(params)
        options = Api::Options.search(params)
        options.delete :tags
        options
      end
    end
  end

end
