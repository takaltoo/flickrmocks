module FlickrMocks
  module Models
    class PhotoDetails
      attr_reader :dimensions
    
      def initialize(photo,dimensions)
        self.dimensions = dimensions
        self.delegated_to_object=  photo
        raise ArgumentError 'owner id for photo did not match owner id for at least one size' unless valid_owner_for_dimensions?
      end

      # returns the name of the author for the photo. When owner_name is not available
      #  owner_username is returned.
      def author
        owner_name.empty? ? owner_username : owner_name
      end

      # returns the owner name for the photo.
      def owner_name
        self.owner.realname
      end

      # returns the owner username for the photo
      def owner_username
        self.owner.username
      end

      # returns the array of PhotoSize objects available for the given photo
      def dimensions
        @dimensions
      end

      # returns the list of acceptable sizes for a photo. Not every photo will have
      # all of these sizes.
      def possible_sizes
        FlickrMocks::Models::Helpers.possible_sizes
      end

      # returns the raw FlicrkRaw response for the photo from flickr
      def photo
        @delegated_to_object
      end

      # compares the complete internal state of two PhotoDetails objects rather than simply
      # comparing object_id's
      def ==(other)
        return false unless other.class == PhotoDetails
        (dimensions == other.dimensions) && (@delegated_to_object == other.instance_eval('@delegated_to_object'))
      end

      # metaprogramming methods

      # delegates methods that are returned by delegated instance method. It also
      # delegates array methods to the @dimensions object
      def method_missing(id,*args,&block)
        return dimensions.sizes.send(id,*args,&block) if array_accessor_methods.include?(id)
        return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method,type=false)
        delegated_instance_methods.include?(method) || old_respond_to?(method)
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods + old_methods
      end

      # returns list of methods that are delegated to other objects
      def delegated_instance_methods
        @delegated_to_object.delegated_instance_methods + array_accessor_methods + [:owner_id] + possible_sizes
      end

      # compares value for internal state rather than object_id
      def initialize_copy(orig)
        super
        @dimensions = @dimensions.clone
        @delegated_to_object = @delegated_to_object.clone
      end



      private
      def dimensions=(object)
        @dimensions = object.class == PhotoSizes ?  object : PhotoSizes.new(object)
      end

      def delegated_to_object=(object)
        @delegated_to_object = object.is_a?(Photo) ?  object : Photo.new(object)
      end

      def valid_owner_for_dimensions?
        dimensions.map do |size|
          photo.id == size.id
        end.inject(true) do |prev,cur| prev && cur end
      end

      def array_accessor_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end

    end
  end
end