module FlickrMocks
  class PhotoDetails
    attr_reader :sizes

    def initialize(photo,sizes)
      raise ArgumentError, 'FlickRaw::Response expected' unless photo.is_a?(FlickRaw::Response) || photo.is_a?(Photo)
      raise ArgumentError, 'FlickRaw::Response expected' unless sizes.is_a?(PhotoSizes) || sizes.is_a?(FlickRaw::ResponseList)

      raise ArgumentError,"Photo id: #{photo.id} did not match Size id: #{size.id}" unless photo.id == sizes[0].source.split('/')[-1].split('_')[0]

      @sizes = sizes.class == FlickrMocks::PhotoSizes ?  sizes : PhotoSizes.new(sizes)
      @delegated_to_object =  photo.is_a?(Photo) ?  photo : Photo.new(photo)

      @delegated_instance_methods = @delegated_to_object.delegated_instance_methods + @delegated_to_object.url_methods
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
      return @delegated_to_object.send(id,*args,&block) if @delegated_instance_methods.include?(id)
      super
    end

    def respond_to?(method,type=false)
      return true if @delegated_instance_methods.include?(method)
      super
    end

    def methods
      @delegated_instance_methods + super
    end

    def public_methods(all=true)
      @delegated_instance_methods + super(all)
    end
    
    def delegated_methods
      @delegated_instance_methods
    end

    def initialize_copy(orig)
      super
      @sizes = @sizes.clone
      @delegated_instance_methods = @delegated_instance_methods.clone
      @delegated_to_object = @delegated_to_object.clone
    end

    def owner_id
      # keeping this away from delegated to methods because it is not a native
      # FlickRaw::Response method
      @delegated_to_object.owner_id
    end

    def ==(other)
      if other.nil?
        false 
      elsif !other.is_a?(self.class)
        false
      elsif @delegated_instance_methods.sort != other.instance_eval('@delegated_instance_methods.sort')
        false
      elsif @sizes != other.sizes
        false
      elsif @delegated_to_object != other.instance_eval('@delegated_to_object')
        false
      else
        true
      end
    end

  end
end