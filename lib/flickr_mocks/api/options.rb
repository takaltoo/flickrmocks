module FlickrMocks
  class Api
    # returns parameter hash for searching for flickr photos based on tags or owner
    def self.search_options(params) 
      return {
        :tags => self.sanitize_tags(params[:search_terms]),
        :user_id =>  params[:owner_id],
        :per_page =>  self.sanitize_per_page(params),
        :page =>  self.sanitize_page(params),
        :license => self.default(:license),
        :media => self.default(:media),
        :extras => self.default(:extras),
        :tag_mode => self.sanitize_tag_mode(params)
      }
    end

    # returns parameter hash for searching for interesting flickr photos
    def self.interesting_options(params) 
      return {
        :date => self.sanitize_time(params),
        :per_page => self.sanitize_per_page(params),
        :page =>  self.sanitize_page(params),
        :extras => self.default(:extras)
      }
    end

    # returns parameter hash for a basic photo search
    def self.photo_options(params) 
      {
        :photo_id => params[:photo_id] || params[:id] || nil,
        :secret => params[:photo_secret] || params[:secret] || nil
      }
    end

    # returns parameter hash for searching for photos of a given author_id
    def self.author_options(params) 
      options = self.search_options(params)   
      options.delete :tags
      options
    end

    # extracts hash of options accepted by PhotoSearch object for basic photo search
    def self.search_params(params) 
      return {
        :search_terms => self.sanitize_tags(params[:search_terms]),
        :owner_id => self.sanitize_tags(params[:owner_id]),
        :base_url => params[:base_url]
      }
    end

    # extracts hash of options accepted by PhotoSearch object for interesting photo search
    def self.interesting_params(params) 
      return {
        :date => params[:date],
        :base_url => params[:base_url]
      }
    end

    # extracts hash of options accepted by CommonsInstitutions object
    def self.commons_institutions_params(params) 
      return {
        :per_page => params[:per_page] || params[:perpage],
        :current_page => params[:current_page] || params[:page] || 1
      }
    end
  end

 
end
