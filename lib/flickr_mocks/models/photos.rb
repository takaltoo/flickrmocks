require 'ostruct'
require 'chronic'

module FlickrMocks
  class Photos
    attr_reader :current_page, :per_page, :total_entries, :search_terms
    attr_reader :collection,:max_entries,:date


    @defaults =  {
      :max_entries => 4000,
      :base_url => '/flickr/search',
      :per_page => 50
    }

    class << self
      attr_accessor :defaults
    end


    def initialize(data,options={})
      # all options are optional unless otherwise specified
      self.collection = data
      self.max_entries = options[:max_entries]
      self.total_entries = data.total
      self.current_page = data.page
      self.per_page = data.perpage
      self.search_terms = options[:search_terms]
      self.date= options[:date]
      self.base_url = options[:base_url]
    end

    def empty?
      @collection.length == 0
    end

    # iterate through the page numbers for the collection
    def each_page
      range = 1..length
      # return an external iterator for page
      range.each do |page|
        yield page
      end
    end


    # yields a photo for every
    def each_photo
      # return an external iterator for photos
      @collection.each do |photo|
        yield photo
      end
    end
    alias each each_photo


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

    def current_page?(options=nil)
      page = case options
      when Hash then options[:page].to_i
      when String then options.to_i
      else nil
      end
      page == @current_page
    end

    def [](index)
      @collection[index]
    end

    def first
      self[0]
    end

    def last
      self[-1]
    end

    def photos
      @collection
    end

    # essentially an alias for total_pages
    def length
      total_pages
    end

    def total_pages
      (capped_total_entries.to_f / @per_page.to_f).ceil
    end

    # Url for retrieving the search results in a given page
    def search_url(options=nil)
      page = options ? options[:page].to_i : current_page
      day = options ? options[:date] : date
      return base_url + '?' + {:search_terms => search_terms}.merge({:page => limit_page(page)}).to_param if search_terms
      return base_url + '?' + {:date => day}.merge({:page => limit_page(page)}).to_param
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

    # used to determine whether the number of search results have been limited
    def capped?
      @total_entries != capped_total_entries
    end

    def base_url
      @base_url || Photos.defaults[:base_url]
    end


    def previous_date(date=nil)
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



    private

    def pages
      range = 1..length
      range
    end

    def max_entries=(value)
      @max_entries = value ? value.to_i : Photos.defaults[:max_entries]
    end

    def collection=(data=nil)
      raise ArgumentError, 'data must not be nil' if data.nil?
      raise ArgumentError, 'data must respond to each' unless data.respond_to? :each

      [:total,:page,:perpage].each do |method|
        raise ArgumentError, "data must respond to #{method}!" unless data.respond_to? method
      end
      collection = []
      data.each do |datum|
        collection.push(Photo.new datum)
      end
      @collection=collection
    end

    def search_terms=(value)
      raise ArgumentError,  "search_terms must respond to :to_s" unless value.respond_to? :to_s
      @search_terms = value.nil? ? value : value.to_s.downcase
    end

    def base_url=(value)
      raise ArgumentError, ':base_url must respond to to_s method.' unless value.respond_to? :to_s
      @base_url = value.to_s.empty? ? nil : value
    end

    def total_entries=(value)
      raise ArgumentError,  "total_entries must not be nil" if value.is_a? NilClass
      @total_entries = value.to_i
      raise ArgumentError,  "total_entries must be greater than 0" if @total_entries < 0
    end

    def date=(value)
      date = case value
        when Time then  value
        when String then Chronic.parse(value)
        else Chronic.parse('yesterday')
      end
      date = date < Chronic.parse('yesterday') ? date : Chronic.parse('yesterday')
      @date = format_date(date)
    end

    def capped_total_entries
      @total_entries.to_i >  max_entries ? max_entries : @total_entries.to_i
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

  end
end