module FlickrMocks
  class Api
    # module contains helper methods that clean up user input
    module Sanitize
      # returns a lowercase stripped version of the supplied string. For example:
      #  Api.sanitize_tags('Shiraz  , HeLLo goodbye, wow') returns 'shiraz,hello goodbye,wow'
      def self.tags(params={})
        case params
        when Hash 
          params[:search_terms].nil? ? nil : params[:search_terms].downcase.split(',').map.each do |v| v.strip end.join(',')
        when nil then
          nil
        when String then
          params.downcase.split(',').map.each do |v| v.strip end.join(',')
        else
          raise ArgumentError
        end

      end

      # returns the per page entry if supplied otherwise returns the default per page value
      def self.per_page(params={})
        case params
        when Hash then
          params[:per_page] || params[:perpage] || Api.default(:per_page)
        when String then
          params.to_i > 0 ? params.to_i.to_s : Api.default(:per_page)
        when Fixnum then
          params > 0 ? params.to_i.to_s :  Api.default(:per_page)
        when nil then
          Api.default(:per_page)
        else
          raise ArgumentError
        end
      end

      # returns the page entry that is a positive non-zero integer
      def self.page(params={})
        case params
        when Hash then
          params[:page].to_i > 0 ? params[:page].to_i.to_s : Api.default(:page) 
        when Fixnum then
          params > 0 ? params.to_s : Api.default(:page)
        when NilClass then
          Api.default(:page)
        when String
          params.to_i > 0 ? params.to_i.to_s : Api.default(:page)
        else
          raise ArgumentError
        end
      end

      # ensures that the :tag_mode tag only contains an accepted value i.e. all | any
      def self.tag_mode(params={})
        case params
        when String then
         Api.default(:flickr_tag_modes).include?(params.to_s.downcase) ?
           params.to_s.downcase : Api.default(:tag_mode)
        when Hash then
          Api.default(:flickr_tag_modes).include?(params[:tag_mode].to_s.downcase.strip) ?
            params[:tag_mode].to_s.downcase.strip : Api.default(:tag_mode)
        when nil then
          Api.default(:tag_mode)
        else
          raise ArgumentError
        end
      end

      # returns a string of format YYYY-MM-DD corresponding to the supplied :date entry.
      # The entry can either be a Time object or a string. If no date entry is supplied,
      # it returns yesterday's date.
      def self.date(params={})
        case params
        when Hash then
          case params[:date]
          when Time then params[:date].strftime('%Y-%m-%d')
          when String then Api::Helpers.date(params[:date])
          else Api::Helpers.date('yesterday')
          end
        when String then Api::Helpers.date(params)
        when Time then params.strftime('%Y-%m-%d')
        else Api::Helpers.date('yesterday')
        end
      end
    end
  end
end