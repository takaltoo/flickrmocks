module FlickrMocks
  class PhotoSearch
    attr_reader :photos,:search_terms,:page,:date

    @defaults =  {
      :page => 1
    }

    @delegated_methods = [:current_page, :per_page, :total_entries,
                                 :photos, :perpage, :capped?, :max_entries]

    class << self
      attr_accessor :defaults
      attr_accessor :delegated_methods
    end

    def initialize(data,options={})
      self.photos = data
      self.search_terms = options[:search_terms]  
      self.page = options[:page]
      self.date = options[:date]
    end

    def default(value)
      PhotoSearch.defaults[value.to_sym]
    end

    def [](index)
      photos[index]
    end

    def first
      photos[0]
    end

    def last
      photos[-1]
    end

    def each
      photos.each do |photo|
        yield photo
      end
    end
    def size
      photos.size
    end

    def method_missing(id,*args,&block)
      return photos.send(id,*args,&block) if delegated_methods.include?(id)
      super
    end

    def respond_to?(method)
        return true if delegated_methods.include?(method)
        super
    end

    def methods
     delegated_methods + super
    end

    def delegated_methods
      PhotoSearch.delegated_methods
    end

    def total_results
      total_entries
    end

    def url_params
      { :search_terms => search_terms,
        :date => (date.nil? && search_terms.empty?) ? Api.time : date
      }.keep_if do |k,v|  !(v.nil? || v.to_s.empty?) end
    end


    def initialize_copy(other)
      super
      @photos = @photos.clone
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(self.class)

      match = [:search_terms,:page,:date].map do |method|
        self.send(method) == other.send(method)
      end.inject(true) do |previous,current| previous && current end
      
      return false unless match

      match = []
      index=-1
      photos.each do |photo|
        index += 1
        match.push(photo == other.photos[index])
      end
      match.inject(true) do |previous,current| previous && current end
    end



    private

    def photos=(data)
      photos = case data
      when FlickRaw::ResponseList then Photos.new(data)
      when Photos then data
      else raise ArgumentError, "expecting object of class Photos or FlickRaw::ResponseList"
      end
      @photos = photos
    end

    def search_terms=(terms=nil)
      terms ||= ''
      raise ArgumentError, "Expecting String but got #{terms.class}" unless terms.is_a?(String)
      @search_terms = terms
    end

    def page=(page=nil)
      page ||= default(:page)
      raise ArgumentError, "Expecting Fixnum but got #{page.class}" unless page.is_a?(Fixnum) or page.is_a?(String)
      @page = page.to_i
    end

    def date=(date=nil)
      raise ArgumentError, "Expecting String but got #{date.class}" unless date.is_a?(String) or date.nil?
      begin
        Chronic.parse(date) unless date.nil?
      rescue
         raise ArgumentError, "#{date} string can not be converted to Time object"
      end   
      @date = date
    end
    
  end
end