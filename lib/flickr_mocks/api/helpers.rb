module FlickrMocks
  class Api
    # returns the default value stored in the class instance variable hash @defaults
    # for the supplied key. 
    def self.default(value) 
      Api.defaults[value.to_sym]
    end

    # returns a date string of format YYYY-MM-DD. If the supplied date is ambiguous
    # it returns yesterday's date in the format YYYY-MM-DD
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
