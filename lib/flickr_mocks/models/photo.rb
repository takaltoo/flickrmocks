module FlickrMocks
  class Photo < SimpleDelegator

    def initialize(photos)
      raise TypeError, 'FlickRaw::Response expected' unless photos.is_a? FlickRaw::Response
      super
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

    def author_url
      FlickRaw.url_photopage self
    end


    def method_missing(id,*args,&block)
      return medium_640 if id.to_sym == :'medium 640'
      super
    end

    def respond_to?(method,type=false)
      return true if method.to_sym == :'medium 640'
      if type
        return self.class.public_instance_methods(false).include?(method.to_sym) || super
      else
        return self.class.instance_methods(false).include?(method.to_sym) || super
      end
    end

  end
end
