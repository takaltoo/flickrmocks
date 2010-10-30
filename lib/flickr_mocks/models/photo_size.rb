module FlickrMocks

  class PhotoSize
    def initialize(size)
      raise TypeError, 'FlickRaw::Response expected' unless size.is_a? FlickRaw::Response
      @delegated_to_object= size
    end

    def size
      label.to_s.downcase.sub(/\s+/,'_')
    end

    def id
      source.split('/')[-1].split('_')[0]
    end

    def secret
      source.split('/')[-1].split('_')[1]
    end

    def ==(other)
      @delegated_to_object == other.instance_eval('@delegated_to_object')
    end

    def initialize_copy(orig)
      super
      @delegated_to_object = @delegated_to_object.clone
    end

    def method_missing(id,*args,&block)
      return @delegated_to_object.send(id,*args,&block) if delegated_methods.include?(id)
      super
    end

    def respond_to?(method,type=false)
      return true if delegated_methods.include?(method)
      super
    end

    def methods
      delegated_methods + super
    end

    def public_methods(all=true)
      delegated_methods + super(all)
    end

    def delegated_methods
     @delegated_to_object.methods(false).push(:flickr_type)
    end
    
  end



end