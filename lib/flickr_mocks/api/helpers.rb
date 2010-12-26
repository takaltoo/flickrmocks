module FlickrMocks
  class Api
    module Helpers
      # returns a date string of format YYYY-MM-DD. If the supplied date is ambiguous
      # it returns yesterday's date in the format YYYY-MM-DD. Sample usage:
      #
      #  self.date('2010-10-10')
      #  self.date('yesterday')
      def self.date(date=nil)
        self.valid_date?(date) ? self.parse_date(date) : self.parse_date('yesterday')
      end
      
      # returns true when supplied date is of format YYYY-MM-DD. Sample usage:
      #
      #   self.valid_date?('2010-10-10')
      def self.valid_date?(date)
        begin
          self.parse_date(date)
          true
        rescue
          false
        end
      end

      private
      def self.parse_date(date)
        Chronic.parse(date).strftime('%Y-%m-%d')
      end

    end
  end
end
