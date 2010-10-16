module FlickrMocks
  class Photos
    attr_reader :current_page,:per_page,:total_entries,:total_pages,:photos
    alias :perpage :per_page

    @defaults =  {
      :max_entries => 4000,
      :per_page => 50
    }

    class << self
      attr_accessor :defaults
    end

    def initialize(data)
      raise ArgumentEror, 'Expecting class of FlickRaw::ResponseList' unless data.instance_of?(FlickRaw::ResponseList)
      self.current_page= data.page
      self.per_page= data.perpage
      self.total_entries= data.total
      self.total_pages = data.pages
      self.photos=  data.photo
    end

    def default(value)
      Photos.defaults[value.to_s.to_sym]
    end

    def capped?
      max_entries < total_entries ? true : false
    end

    def max_entries
      default(:max_entries)
    end

    def each
      photos.each do |photo|
        yield photo
      end
    end

    def first
      photos[0]
    end

    def last
      photos[-1]
    end

    def [](index)
      photos[index]
    end

    def pages
      max_pages = default(:max_entries)/perpage
      total_pages > max_pages ? max_pages : total_pages
    end

    def initialize_copy(orig)
      super
      @photos = @photos.map do |photo|
        photo.clone
      end
    end

    def ==(other)
      return false if other.nil?
      # check basic methods to see if they are equal
      match = [:current_page, :per_page, :total_entries, :total_pages, :perpage].map do |method|
        return false unless other.respond_to?(method)
        self.send(method) == other.send(method)
      end.inject(true) do |previous,current|
        previous && current
      end
      
      return false unless match
      
      # check photos
      index = -1
      photos.map do |photo|
        index +=1
        photo == other.photos[index]
      end.inject(true) do |previous,current|
        previous && current
      end
    end

    def size
      photos.size
    end
    
    private
    def current_page=(value)
      raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
      @current_page=value.to_i
    end

    def per_page=(value)
      raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
      @per_page=value.to_i
    end

    def total_entries=(value)
      raise ArgumentError,"Expected Fixnum but was #{value.class}"  unless value.is_a?(Fixnum) or value.is_a?(String)
      @total_entries=value.to_i
    end

    def total_pages=(value)
      raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
      @total_pages=value.to_i
    end

    def photos=(photos)
      raise ArgumentError,"Expected argument that responds to :each but got class #{photos.class}" unless photos.respond_to?(:each)
      results = []
      photos.each do |photo|
        raise ArgumentError,"Expected FlickRaw::Response but was #{value.class}" unless photo.is_a?(FlickRaw::Response)
        results.push(Photo.new(photo))
      end
      @photos=results
    end
  end
end