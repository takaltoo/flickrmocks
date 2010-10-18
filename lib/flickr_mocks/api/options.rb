module FlickrMocks
  class Api
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

    def self.interesting_options(params)
      return {
        :date => self.sanitize_time(params),
        :per_page => self.sanitize_per_page(params),
        :page =>  self.sanitize_page(params),
        :extras => self.default(:extras)
      }
    end

    def self.photo_options(params)
      {
        :photo_id => params[:photo_id] || params[:id] || nil,
        :secret => params[:photo_secret] || params[:secret] || nil
      }
    end

    def self.author_options(params)
      options = self.search_options(params)   
      options.delete :tags
      options
    end

    def self.search_params(params)
      return {
        :search_terms => self.sanitize_tags(params[:search_terms]),
        :owner_id => self.sanitize_tags(params[:owner_id]),
        :base_url => params[:base_url]
      }
    end

    def self.interesting_params(params)
      return {
        :date => params[:date],
        :base_url => params[:base_url]
      }
    end
  end

 
end
