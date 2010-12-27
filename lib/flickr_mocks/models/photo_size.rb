module FlickrMocks
  module Models
    class PhotoSize
      def initialize(object)
        self.delegated_to_object= object
      end

      # returns the string that contains the photo's size
      def size
        label.to_s.downcase.sub(/\s+/,'_')
      end

      # returns the flickr id for the given photo
      def id
        source.split('/')[-1].split('_')[0]
      end

      # returns the flickr secret for the given photo
      def secret
        source.split('/')[-1].split('_')[1]
      end

      # compares the complete internal state of two PhotoDetails objects rather than simply
      # comparing object_id's
      def ==(other)
        @delegated_to_object == other.instance_eval('@delegated_to_object')
      end

      # metaprogramming methods
     
      # returns list of methods that are delegated to other objects
      def delegated_instance_methods
        @delegated_to_object.methods(false).push(:flickr_type)
      end

     # delegates methods that are returned by delegated instance method. It also
      # delegates array methods to the @dimensions object
      def method_missing(id,*args,&block)
        return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method,type=false)
        return true if delegated_instance_methods.include?(method)
        old_respond_to?(method,type)
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods + old_methods
      end

      # compares value for internal state rather than object_id
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
end