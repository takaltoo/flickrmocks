module FlickrMocks
  class PhotosSearchssss
    attr_reader :owner_id,:date
    attr_accessor :usable_entries

    @defaults =  {
      :base_url => '/flickr/search'
    }

    class << self
      attr_accessor :defaults
    end

    def initialize(data,options={})
      self.owner_id = options[:owner_id]
      self.search_terms = options[:search_terms]
    end

    # iterate through the page numbers for the collection
    def each_page
      range = 1..length
      # return an external iterator for page
      range.each do |page|
        yield page
      end
    end

    def pages_with_url
      data = []
      pages.each do |page|
        datum = Pages.new :page => page,
                                         :current_page =>  @current_page,
                                        :url => search_url(:page => page)
        data.push datum
      end
      data
    end
     # essentially an alias for total_pages
    def length
      total_pages
    end

    def single_page?
      total_pages == 1
    end
    def multi_page?
      total_pages >= 2
    end
    def total_pages
      (capped_total_entries.to_f / @per_page.to_f).ceil
    end

    # Url for retrieving the search results in a given page
    def search_url(options=nil)
        page ||= current_page
        day ||= date
        case options
        when Hash then
          page = (options[:page] ? options[:page] : page).to_i
          day = options[:date] ? options[:date] :day
        end

      return base_url + '?' + params_url(:search_terms => search_terms, :owner_id => owner_id,:page => limit_page(page)) if search_terms || owner_id
      return base_url + '?' + params_url(:date => day,:page => limit_page(page)) if day

    end
    def prev_date_url(options=nil)
      date = extract_date options
      search_url :date => prev_date(date)
    end
    def next_date_url(options=nil)
      date = extract_date options
      next_date(date) == format_date(date) ? nil : search_url(:date => next_date(date))
    end

    def next_page(options=nil)
      value = case options
      when Hash then options ? options[:page].to_i : @current_page
      when nil then @current_page
      else options.to_i
      end
      limit_page value + 1
    end

    def prev_page(value=nil)
      value ||=@current_page
      value -= 1
      limit_page value
    end
    def base_url
      @base_url || Photos.defaults[:base_url]
    end

    def prev_date(date=nil)
      date ||=@date
      format_date Chronic.parse(date) - ChronicDuration.parse('1 day')
    end

    def next_date(options=nil)
      date = case options
        when Time then format_date options
        when Hash then options[:date]
        when String then options
        else @date
      end
      if Chronic.parse(date) >= Chronic.parse('yesterday')
        format_date Chronic.parse('yesterday')
      else
        format_date Chronic.parse(date) + ChronicDuration.parse('1 day')
      end
    end
        def format_date(date)
      case date
        when Time then date.strftime('%Y-%m-%d')
        when String then Chronic.parse(date).strftime('%Y-%m-%d')
      end
    end

    def usable_entries
      return @usable_entries if @usable_entries
      count =0
      each_photo do |photo|
        count +=1 if photo.license.to_i >= 4
      end
      @usable_entries = count
      @usable_entries
    end

    def usable_entries?
      usable_entries == 0 ? false : true
    end

    private
      def pages
        range = 1..length
        range
      end
 range = 1..length
      # return an external iterator for page
      range.each do |page|
        yield page
      end
    def current_page=(value)
      @current_page = value.to_i
      raise ArgumentError, "current_page must be greater than 1" if @current_page < 1
    end

    def per_page=(value)
      raise ArgumentError,
        "per_page must be greater than or equal to 1" if value < 1
        @per_page =  value.to_i
    end

    def limit_page(page)
      page = page > total_pages ? total_pages : page
      page < 1 ? 1 : page
    end

    def extract_date(options)
       case options
          when nil then @date
          when Hash then options[:date] ? options[:date] : @date
          when String then options
          when Time then format_date options
          else @date
      end
    end
    def params_url(params)
      result = {}
      params.each_pair do |k,v|
        result[k] = v if v
      end
      Helpers.to_param(result)
    end

  end
end