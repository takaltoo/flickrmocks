module FlickrMocks
  class Api
    def self.sanitize_tags(value=nil)
      value.nil? ? value : value.downcase.split(',').map.each do |v| v.strip end.join(',')
    end

    def self.sanitize_per_page(params={})
      params[:per_page] || params[:perpage] || self.default(:per_page)
    end

    def self.sanitize_page(params={})
      [nil,0,'0'].include?(params[:page]) ? '1' : params[:page].to_i.to_s
    end

    def self.sanitize_tag_mode(params={})
      self.default(:flickr_tag_modes).include?(params[:tag_mode].to_s.downcase.strip) ?
        params[:tag_mode].to_s.downcase.strip : self.default(:tag_mode)
    end

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