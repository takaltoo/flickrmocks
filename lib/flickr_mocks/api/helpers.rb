module FlickrMocks
  class Api
    module Helpers
      # returns a date string of format YYYY-MM-DD. If the supplied date is ambiguous
      # it returns yesterday's date in the format YYYY-MM-DD
      def self.date(date=nil)
        begin
          date = Chronic.parse(date).strftime('%Y-%m-%d')
          date ? date : Chronic.parse('yesterday').strftime('%Y-%m-%d')
        rescue
          Chronic.parse('yesterday').strftime('%Y-%m-%d')
        end
      end
      
      # checks to see whether supplied date is of format YYYY-MM-DD
      def self.valid_date?(date)
        begin
          Chronic.parse(date).strftime('%Y-%m-%d')
          true
        rescue
          false
        end
      end

    end
  end
end
