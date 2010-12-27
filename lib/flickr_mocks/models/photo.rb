module FlickrMocks
  module Models
    class Photo
      def initialize(photo)
        self.delegated_to_object = photo
        @delegated_instance_methods = @delegated_to_object.methods(false).push(:flickr_type)
        @extended_photo = photo.methods.include?(:originalsecret)
      end

      # Return url for square sized photo
      def square
        FlickRaw.url_s self
      end

      # returns url for original sized photo
      def original
        respond_to?(:originalsecret) ? FlickRaw.url_o(self) : nil
      end

      # returns url for thumbnail sized photo
      def thumbnail
        FlickRaw.url_t self
      end

      # returns url for small sized photo
      def small
        FlickRaw.url_m self
      end

      # returns url for medium sized photo
      def medium
        FlickRaw.url self
      end

      # returns url for large sized photo
      def large
        FlickRaw.url_b self
      end

      # returns url for medium 640 sized photo
      def medium_640
        FlickRaw.url_z self
      end

      # return url for copyright owner of photo
      def owner_url
        FlickRaw.url_photopage self
      end

      # returns Flickr id for owner of photo
      def owner_id
        case owner
        when String then owner
        else
          return owner.nsid if owner.respond_to?(:nsid)
          return owner.to_s
        end
      end

      # returns Flickr id for photo
      def photo_id
        id
      end

      # returns true if photo license can be used for commercial purposes
      def usable?
        FlickrMocks::Api.default(:usable_licenses).include?(license.to_i)
      end

      # compares two objects by value rather than object_id
      def ==(other)
        @delegated_to_object == other.instance_eval('@delegated_to_object')
      end

      # compares value for internal state rather than object_id
      def initialize_copy(orig)
        super
        @delegated_to_object = @delegated_to_object.clone
      end
      
      # returns the list of methods that are delegated by object
      def delegated_instance_methods
        @delegated_instance_methods
      end

      # delegates methods that are returned by delegated instance method as well as method
      # :'method 640'
      def method_missing(id,*args,&block)
        return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
        return medium_640 if id.to_sym == :'medium 640'
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method,type=false)
        return true if method.to_sym == :'medium 640'
        return true if delegated_instance_methods.include?(method)
        old_respond_to?(method,type)
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods + old_methods
      end


      private
      def delegated_to_object=(object)
        raise ArgumentError, "FlickRaw::ResponseList expected" if object.class == FlickRaw::ResponseList
        raise ArgumentError, 'FlickRaw::Response expected' unless object.class ==  FlickRaw::Response
        @delegated_to_object = object
      end
    end
  end
end
