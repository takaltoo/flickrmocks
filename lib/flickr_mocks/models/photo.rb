module FlickrMocks

  class Photo
    def initialize(photo)
      raise TypeError, "FlickRaw::ResponseList expected" if photo.is_a? FlickRaw::ResponseList
      raise TypeError, 'FlickRaw::Response expected' unless photo.is_a? FlickRaw::Response
      @delegated_to_object = photo
      @delegated_instance_methods = @delegated_to_object.methods(false).push(:flickr_type)
      @extended_photo = photo.methods.include?(:originalsecret)
    end

    # Return urls for various sizes
    def square
      FlickRaw.url_s self
    end

    def original
      respond_to?(:originalsecret) ? FlickRaw.url_o(self) : nil
    end

    def thumbnail
      FlickRaw.url_t self
    end

    def small
      FlickRaw.url_m self
    end

    def medium
      FlickRaw.url self
    end

    def large
      FlickRaw.url_b self
    end

    def medium_640
      FlickRaw.url_z self
    end

    def owner_url
      FlickRaw.url_photopage self
    end


    def owner_id
      case owner
      when String then owner
      else
        return owner.nsid if owner.respond_to?(:nsid)
        return owner.to_s
      end
    end

    def photo_id
      id
    end

    def ==(other)
       @delegated_to_object == other.instance_eval('@delegated_to_object')
    end

    def initialize_copy(orig)
      super
      @delegated_to_object = @delegated_to_object.clone
    end

    def delegated_instance_methods
      @delegated_instance_methods
    end


    def method_missing(id,*args,&block)
      return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
      return medium_640 if id.to_sym == :'medium 640'
      super
    end

    alias :old_respond_to? :respond_to?
    def respond_to?(method,type=false)
      return true if method.to_sym == :'medium 640'
      return true if delegated_instance_methods.include?(method)
      old_respond_to?(method,type)
    end

    alias :old_methods :methods
    def methods
      delegated_instance_methods + old_methods
    end
  end

end
