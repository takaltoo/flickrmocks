module FlickrMocks
  class Api
    # helper methods that help to clean up user supplied values. Module is
    # used internally.
    module Sanitize
      # returns a lowercase stripped version of the supplied comma separated string.
      # Sample usage:
      #
      #  Api.sanitize_tags('Shiraz  , HeLLo goodbye, wow')
      #  returns 'shiraz,hello goodbye,wow'
      def self.tags(value=nil)
        case value
        when nil then
          nil
        when String then
          value.downcase.split(',').map.each do |v| v.strip end.join(',')
        else
          raise ArgumentError
        end
      end

      # returns lowercase stripped version of the supplied string stored in the
      # :search_terms key of the supplied hash. Sample usage:
      #
      #  self.sanitize_tags(:search_terms => 'Shiraz  , HeLLo goodbye, wow')
      #  returns 'shiraz,hello goodbye,wow'
      def self.tags_hash(options={})
        raise ArgumentError unless options.is_a?(Hash)
        self.tags(options[:search_terms])
      end

      # returns the per page entry if supplied otherwise returns the default per page value.
      # Sample usage:
      #
      #  self.per_page('10')
      #  returns '10'
      def self.per_page(value=nil)
        case value
        when String then
          value.to_i > 0 ? value.to_i.to_s : Api.default(:per_page)
        when Fixnum then
          value > 0 ? value.to_i.to_s :  Api.default(:per_page)
        when nil then
          Api.default(:per_page)
        else
          raise ArgumentError
        end
      end

      # returns the per page entry stored in the :per_page key of the supplied options hash.
      # Sample usage:
      #
      #  self.per_page_hash(:per_page => '10')
      #  returns '10'
      def self.per_page_hash(options={})
          if options[:per_page]
            self.per_page(options[:per_page])
          elsif options[:perpage]
            self.per_page(options[:perpage])
          else
            self.per_page(nil)
          end
      end

      # returns the page number. Ensures that return value is string containing an integer
      # greater than 0. When nonsensical page supplied, default page '1' is returned.
      # Sample usage:
      #
      #   self.page('20')
      #   returns '20'
      def self.page(value={})
        case value
        when Fixnum then
          value > 0 ? value.to_s : Api.default(:page)
        when NilClass then
          Api.default(:page)
        when String
          value.to_i > 0 ? value.to_i.to_s : Api.default(:page)
        else
          raise ArgumentError
        end
      end

      # returns the page number contained in the :page key of the supplied hash.
      # Sample usage:
      #
      #  self.page(:page => '20')
      #  returns '20'
      def self.page_hash(options={})
          self.page(options[:page])
      end

      # returns tag mode. It ensures that a valid tag mode is returned. If an invalid
      # tag_mode is supplied it returns the default tag mode 'all'. Sample usage:
      #
      #  self.tag_mode('any')
      #  returns 'any'
      def self.tag_mode(value=nil)
        case value
        when String then
         Api.default(:possible_tag_modes).include?(value.to_s.downcase) ?
           value.to_s.downcase : Api.default(:tag_mode)
        when nil then
          Api.default(:tag_mode)
        else
          raise ArgumentError
        end
      end

      # returns tag_mode contained in the :tag_mode key of the supplied hash.
      # Sample usage:
      #
      #   self.tag_mode(:tag_mode => 'any')
      #   returns 'any'
      def self.tag_mode_hash(options={})
        self.tag_mode(options[:tag_mode].to_s.downcase.strip)
      end

      # returns a string of format YYYY-MM-DD. Accepts either a Time object or a string as
      # an argument. If invalid date supplied the string corresponding to yesterday's date is returned.
      # Sample usage:
      #   self.date('2010-10-10')
      #   returns => '2010-10-10'
      def self.date(value=nil)
        case value
        when String then Api::Helpers.date(value)
        when Time then value.strftime('%Y-%m-%d')
        else Api::Helpers.date('yesterday')
        end
      end

      # returns string of format YYYY-MM-DD corresponding to the value stored in the :date
      # key of the options hash. Sample usage:
      #
      #  self.date_hash(:date => '2010-10-10')
      #  returns '2010-10-10'
      def self.date_hash(options={})
        self.date(options[:date])
      end
    end
  end
end
