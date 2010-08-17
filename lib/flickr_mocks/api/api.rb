module FlickrMocks
  class Api
    # FlickRaw.api_key = APP_CONFIG['flickr_api_key']
    FlickRaw.api_key = '247c5c08074816140d8ee7e74ef101e1'

    @defaults = {
      :per_page => '200',
      :license => '4,5,6,7',
      :media => 'photos',
      :extras => 'm_dims',
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
      Photos.new photos,params
    end


    def self.size(params)
      size =  params[:size] ? params[:size].downcase.to_sym : nil
    end


    # Helper methods for extracting parameters/options

    def self.photo_options(params)
      {
        :photo_id => params[:photo_id] || params[:id] || nil,
        :secret => params[:photo_secret] || params[:secret] || nil
      }
    end


    def self.search_options(params)
      return {
        :tags => self.sanitize_tags(params[:search_terms]),
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
        :date => params[:date] ? self.sanitize_time(params) : Time.now,
        :per_page => self.sanitize_per_page(params),
        :page =>  self.sanitize_page(params)
      }
    end

    def self.search_params(params)
      return {
        :search_terms => self.sanitize_tags(params[:search_terms]),
        :base_url => params[:base_url]
      }
    end

    def self.sanitize_tags(value)
      value.nil? ? value : value.downcase.split(',').map.each do |v| v.strip end.join(',')
    end

    def self.sanitize_per_page(params)
      params[:per_page] || params[:perpage] || self.default(:per_page)
    end

    def self.sanitize_page(params)
      [nil,0,'0'].include?(params[:page]) ? '1' : params[:page].to_i.to_s
    end

    def self.sanitize_tag_mode(params)
      self.default(:flickr_tag_modes).include?(params[:tag_mode].to_s.downcase.strip) ?
        params[:tag_mode].to_s.downcase.strip : self.default(:tag_mode)
    end

    def self.sanitize_time(params)
      date = params[:date]
      case date
      when Time then date.strftime('%Y-%m-%d')
      when String then self.time(date)
      else self.time('yesterday')
      end
    end

    def self.time(date=nil)
      begin
        date = Chronic.parse(date).strftime('%Y-%m-%d')
        date ? date : Chronic.parse('yesterday').strftime('%Y-%m-%d')
      rescue
        Chronic.parse('yesterday').strftime('%Y-%m-%d')
      end
    end

    # default control values
    def self.default(value)
      Api.defaults[value.to_sym]
    end

    private
    # Not required for testing, simple wrappers for flickr* methods
    def self.flickr_photos(params)
      flickr.photos.search self.search_options(params)
    end

    def self.flickr_photo(params)
      flickr.photos.getInfo self.photo_options(params)
    end

    def self.flickr_photo_sizes(params)
      flickr.photos.getSizes self.photo_options(params)
    end

    def self.flickr_interestingness(params)
      flickr.interestingness.getList self.interesting_options(params)
    end

  end
end