module FlickrMocks

  class PhotoSize
    def initialize(object)
      self.delegated_to_object= object
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

    # metaprogramming methods
    def delegated_instance_methods
      @delegated_to_object.methods(false).push(:flickr_type)
    end

    def method_missing(id,*args,&block)
      return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
      super
    end

    alias :old_respond_to? :respond_to?
    def respond_to?(method,type=false)
      return true if delegated_instance_methods.include?(method)
      old_respond_to?(method,type)
    end

    alias :old_methods :methods
    def methods
      delegated_instance_methods + old_methods
    end

    # cloning and copying methods
    def initialize_copy(orig)
      super
      @delegated_to_object = @delegated_to_object.clone
    end


  private

    def delegated_to_object=(data)
      raise ArgumentError, 'FlickRaw::Response expected' if data.class == FlickRaw::ResponseList
      raise ArgumentError, 'FlickRaw::Response expected' unless data.is_a? FlickRaw::Response
      @delegated_to_object = data
    end
  end
end