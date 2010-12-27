module FlickrMocks
  module Models
    class PhotoSizes
      def initialize(object)
        self.delegated_to_object= object
      end

      # returns the flickr id for the stored photo
      def id
        @delegated_to_object.first.id
      end

      # returns the flickr secret for the stored photo
      def secret
        @delegated_to_object.first.secret
      end

      # returns array of PhotoSize objects available for the given photo
      def sizes
        @delegated_to_object
      end

      # returns an array of symbols for the available sizes for the given photo
      def available_sizes
        @available_sizes ||= sizes.map do |size|
          size.size.to_sym
        end
        @available_sizes
      end

      # returns a collection of sizes that can be used directly for WillPaginate.
      def collection
        @collection ||= ::WillPaginate::Collection.create(1, sizes.length, sizes.length) do |obj|
          obj.replace(sizes)
        end
        @collection
      end

      # returns a string that encodes the name, width and height for all dimensions
      # available for the photo. Sample return string is:
      #
      #  "square:75x75,thumbnail:67x100,small:161x240,medium:335x500"
      def to_s
        PhotoDimensions.new(@delegated_to_object.map do |size|
            "#{size.size}:#{size.width}x#{size.height}"
          end.join(',')).to_s
      end

      # compares the complete internal state of two PhotoDetails objects rather than simply
      # comparing object_id's
      def ==(other)
        return false unless self.class == other.class
        @delegated_to_object == other.instance_eval('@delegated_to_object')
      end

      # returns an array that contains the symbol names for the possible sizes
      # that a photo can have. Please note that not all sizes are available for
      # every photo.
      def possible_sizes
        Models::Helpers.possible_sizes
      end

      # metaprogramming methods
      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods + old_methods
      end

      # delegates methods that are returned by delegated instance method.
      def method_missing(id,*args,&block)
        return @delegated_to_object.send(id,*args,&block) if  delegated_instance_methods.include?(id)
        return nil if possible_sizes.include?(name)
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method)
        old_respond_to?(method) || delegated_instance_methods.include?(method)
      end

      # returns true for delegated and regular methods
      def delegated_instance_methods
        possible_sizes + FlickrMocks::Models::Helpers.array_accessor_methods
      end

      # compares value for internal state rather than object_id
      def initialize_copy(orig)
        super
        @delegated_to_object = @delegated_to_object.map do |data|
          data.clone
        end
      end

      private

      def delegated_to_object=(data)
        raise ArgumentError, 'FlickRaw::Response expected' unless data.class == FlickRaw::ResponseList
        @delegated_to_object = []
        data.each do |datum|
          @delegated_to_object.push PhotoSize.new datum
        end
      end
    

    end
  end

end