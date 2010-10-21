module FlickrMocks

  class PhotoSize
    def initialize(size)
      raise TypeError, 'FlickRaw::Response expected' unless size.is_a? FlickRaw::Response
      @__delegated_to_object__= size
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
      @__delegated_to_object__ == other.instance_eval('@__delegated_to_object__')
    end

    def initialize_copy(orig)
      super
      @__delegated_to_object__ = @__delegated_to_object__.clone
    end

    def method_missing(id,*args,&block)
      return @__delegated_to_object__.send(id,*args,&block) if delegated_methods.include?(id)
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
     @__delegated_to_object__.methods(false).push(:flickr_type)
    end
    
  end



end