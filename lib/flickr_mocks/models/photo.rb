module FlickrMocks
  class Photo 

    @url_methods =[:square,:thumbnail,:small,:medium,:large,:medium_640,:owner_url]
    
    class<< self
      attr_accessor :url_methods
    end



    def initialize(photo)
      raise TypeError, 'FlickRaw::Response expected' unless photo.is_a? FlickRaw::Response
      @__delegated_to_object__= photo
      @__delegated_methods__ = @__delegated_to_object__.methods(false).push(:flickr_type)
      @extended_photo = photo.methods.include?(:originalsecret)
    end

    # Return urls for various sizes
    def square
      FlickRaw.url_s self
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
       @__delegated_to_object__ == other.instance_eval('@__delegated_to_object__')
    end

    def initialize_copy(orig)
      super
      @__delegated_to_object__ = @__delegated_to_object__.clone
    end


    def method_missing(id,*args,&block)
      return @__delegated_to_object__.send(id,*args,&block) if delegated_methods.include?(id)
      return medium_640 if id.to_sym == :'medium 640'
      super
    end

    def respond_to?(method,type=false)
      return true if method.to_sym == :'medium 640'
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
      @__delegated_methods__
    end
    
    def url_methods
      Photo.url_methods
    end
  end
end
