module FlickrMocks
  class Api
    # returns a lowercase stripped version of the supplied string. For example:
    #  Api.sanitize_tags('Shiraz  , HeLLo goodbye, wow') returns 'shiraz,hello goodbye,wow'
    def self.sanitize_tags(value=nil) 
      value.nil? ? value : value.downcase.split(',').map.each do |v| v.strip end.join(',')
    end

    # returns the per page entry if supplied otherwise returns the default per page value
    def self.sanitize_per_page(params={}) 
      params[:per_page] || params[:perpage] || self.default(:per_page)
    end

    # returns the page entry that is a positive non-zero integer
    def self.sanitize_page(params={}) 
      [nil,0,'0'].include?(params[:page]) ? '1' : params[:page].to_i.to_s
    end

    # ensures that the :tag_mode tag only contains an accepted value i.e. all | any
    def self.sanitize_tag_mode(params={}) 
      self.default(:flickr_tag_modes).include?(params[:tag_mode].to_s.downcase.strip) ?
        params[:tag_mode].to_s.downcase.strip : self.default(:tag_mode)
    end

    # returns a string of format YYYY-MM-DD corresponding to the supplied :date entry.
    # The entry can either be a Time object or a string. If no date entry is supplied,
    # it returns yesterday's date. 
    def self.sanitize_time(params={}) 
      date = params[:date]
      case date
      when Time then date.strftime('%Y-%m-%d')
      when String then self.time(date)
      else self.time('yesterday')
      end
    end
  end
end