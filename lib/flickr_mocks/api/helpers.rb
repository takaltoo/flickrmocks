module FlickrMocks
  class Api
    # default control values
    def self.default(value)
      Api.defaults[value.to_sym]
    end

    def self.time(date=nil)
      begin
        date = Chronic.parse(date).strftime('%Y-%m-%d')
        date ? date : Chronic.parse('yesterday').strftime('%Y-%m-%d')
      rescue
        Chronic.parse('yesterday').strftime('%Y-%m-%d')
      end
    end


  end
end
