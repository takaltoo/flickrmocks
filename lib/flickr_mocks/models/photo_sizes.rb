
module FlickrMocks
  class PhotoSizes
    attr_reader :sizes,:available_sizes
    alias_method :all, :sizes
    @possible_sizes = [:square, :thumbnail, :small, :medium, :medium_640, :large, :original]

    class << self
      attr_accessor :possible_sizes
    end

    def initialize(object)
      raise TypeError, 'FlickRaw::Response expected' unless object.is_a? FlickRaw::Response
      self.sizes = object
      self.available_sizes=@sizes
    end

    def [](index)
      @sizes[index]
    end

    def last
      @sizes[-1]
    end

    def first
      @sizes[0]
    end
    
    def id
      @sizes.first.id
    end

    def secret
      @sizes.first.secret
    end

    def method_missing(name,*args,&block)
      return @sizes[size_index name] if size_index? name
      return nil if PhotoSizes.possible_sizes.include?(name)
      super
    end
    
    def methods
      PhotoSizes.possible_sizes + super
    end

    def each
      @sizes.each do |photo|
        yield photo
      end
    end

    def empty?
      @sizes.empty?
    end

    def size
      all.size
    end



    def to_s
      result = []
      @sizes.each do |size|
        result.push "#{size.size}:#{size.width}x#{size.height}"
      end
      PhotoDimensions.new(result.join(',')).to_s
    end

    def ==(other)
      return false unless @available_sizes == (other.respond_to?(:available_sizes) ? other.available_sizes : nil)
      return false unless other.respond_to?(:sizes)
      index = -1
      sizes.map do |size|
        index += 1
        size == other[index]
      end.inject(true) do |previous,current|
        previous && current
      end
    end

    def initialize_copy(orig)
      super
      @sizes = @sizes.clone.map do |data|
        data.clone
      end
      @available_sizes = @available_sizes.clone
    end


    private
    def available_sizes=(data)
      @available_sizes=[]
      data.each do |datum|
        @available_sizes.push datum.size.to_sym
      end
    end

    def sizes=(data)
      @sizes=[]
      data.each do |datum|
        @sizes.push PhotoSize.new datum
      end
    end
    
    def size_index(name)
      @available_sizes.find_index name.to_s.downcase.sub(/\s+/,'_').to_sym
    end

    def size_index?(name)
      !!size_index(name)
    end

  end
end

