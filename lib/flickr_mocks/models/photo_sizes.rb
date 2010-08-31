
module FlickrMocks
  class PhotoSizes
    attr_reader :sizes,:available_sizes
    alias_method :all, :sizes



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

    def method_missing(name,*args)
      return @sizes[size_index :'medium 640'] if name.downcase.to_sym == :medium_640
      return @sizes[size_index name] if size_index? name
      super
    end

    def each
      @sizes.each do |photo|
        yield photo
      end
    end

    def empty?
      @sizes.empty?
    end

    # required for HOBO I think?
    def member_class
    end

    def size_index(name)
      @available_sizes.find_index name.to_s.downcase.sub(/\s+/,'_').to_sym
    end

    def size_index?(name)
      !!size_index(name)
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

  end
end

