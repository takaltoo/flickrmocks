module FlickrMocks
  class PhotoDetails
    attr_reader :sizes

    def initialize(photo,sizes)
      raise ArgumentError, 'FlickRaw::Response expected' unless photo.is_a?(FlickRaw::Response) || photo.is_a?(Photo)
      raise ArgumentError, 'FlickRaw::Response expected' unless sizes.is_a?(PhotoSizes) || sizes.is_a?(FlickRaw::ResponseList)

      raise ArgumentError,"Photo id: #{photo.id} did not match Size id: #{size.id}" unless photo.id == sizes[0].source.split('/')[-1].split('_')[0]

      @sizes = sizes.class == FlickrMocks::PhotoSizes ?  sizes : PhotoSizes.new(sizes)
      @__delegated_to_object__ =  photo.is_a?(Photo) ?  photo : Photo.new(photo)

      @__delegated_methods__ = @__delegated_to_object__.delegated_methods
    end

    def owner_name
      self.owner.realname
    end
    
    def owner_username
      self.owner.username
    end

    # requires originalsecret which is in the detail view but not generic
    def original
      FlickRaw.url_o self
    end

    # Methods that make the delegated methods appear as if they were non-delegated
    def method_missing(id,*args,&block)
      return @__delegated_to_object__.send(id,*args,&block) if @__delegated_methods__.include?(id)
      super
    end

    def respond_to?(method,type=false)
      return true if @__delegated_methods__.include?(method)
      super
    end

    def methods
      @__delegated_methods__ + super
    end

    def public_methods(all=true)
      @__delegated_methods__ + super(all)
    end
    
    def delegated_methods
      @__delegated_methods__
    end

    def initialize_copy(orig)
      super
      @sizes = @sizes.clone
      @__delegated_methods__ = @__delegated_methods__.clone
      @__delegated_to_object__ = @__delegated_to_object__.clone
    end

    def ==(other)
      if other.nil?
        false 
      elsif !other.is_a?(self.class)
        false
      elsif @__delegated_methods__.sort != other.instance_eval('@__delegated_methods__.sort')
        false
      elsif @sizes != other.sizes
        false
      elsif @__delegated_to_object__ != other.instance_eval('@__delegated_to_object__')
        false
      else
        true
      end
    end

  end
end