require 'ostruct'

module FlickrMocks
  module Models
    class PhotoDimensions
      # sizes that are recognized by class. The sizes are in order from smallest to largest
      @regexp_size = /^[a-z]+(_\d+)?:\d+x\d+(,[a-z]+(_\d+)?:\d+x\d+)*$/


      class << self
        attr_reader :regexp_size
      end
    
      def initialize(data)
        self.delegated_to_object = data
      end

      # returns array of symbols for the sizes available for a given photo
      def available_sizes
        map do |dimension|
          dimension.size
        end
      end

      # returns array of symbols for possible sizes of a given photo. Not every photo
      # will have all of the returned sizes.
      def possible_sizes
        FlickrMocks::Models::Helpers.possible_sizes
      end
      
      # returns the array of OpenStruct objects available for the given photo size
      def dimensions
        @delegated_to_object
      end

      # returns a collection of photo sizes that can be used directly for WillPaginate.
      def collection
        @collection ||= ::WillPaginate::Collection.create(1, available_sizes.length, available_sizes.length) do |obj|
          obj.replace(dimensions)
        end
        @collection
      end

      # returns a string that encodes the size, width and height for the photo.
      # Sample string returned would be:
      #  "small:100x200,large:300x500"   --> ie small photo, width of 100 and lenght of 200 
      def to_s
        dimensions.map do  |dimension|
          [dimension.size,[dimension.width,dimension.height].join('x')].join(':')
        end.join(',')
      end

      # compares value for internal state rather than object_id
      def ==(other)
        return false unless other.class.should == self.class
        to_s == other.to_s
      end

      # metaprogramming methods
      alias :old_respond_to? :respond_to?
      
      # returns true for delegated and regular methods
      def respond_to?(method)
        valid_size?(method) || delegated_instance_methods.include?(method) || old_respond_to?(method)
      end

      # delegates methods that are returned by delegated instance method
      def method_missing(id,*args,&block)
        return get_size(id,*args,&block) if  valid_size?(id)
        return dimensions.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        available_sizes + delegated_instance_methods + old_methods
      end

      # returns the list of methods that are delegated by object
      def delegated_instance_methods
        Models::Helpers.array_accessor_methods
      end
    
      # compares value for internal state rather than object_id
      def initialize_copy(other)
        super
        @delegated_to_object = @delegated_to_object.map do |object|
          object.clone
        end
      end


      private
      def delegated_to_object=(data)
        raise(ArgumentError, "Invalid #{data} must respond to :to_s") unless data.respond_to?(:to_s)
        # expecting strings of type: "square:1x1,thumbnail:2x2,small:3x3,medium:4x4,medium_640:4x4,large:5x5,original:6x6"
        raise(ArgumentError, "Invalid string format") unless data =~ PhotoDimensions.regexp_size

        @delegated_to_object= data.to_s.split(',').map do |fields|
          size,dim = fields.split(':')
          size= size.to_sym
          raise(ArgumentError,"Invalid size provided #{size}") unless valid_size?(size)
          width,height=dim.split(/x/)
          OpenStruct.new :size => size,:width => width.to_i,:height => height.to_i
        end
      end

      def valid_size?(data)
        possible_sizes.include?(data.to_sym)
      end

      def get_size(size)
        dimensions.keep_if do |dimension|
          dimension.size == size
        end.first
      end

    end
  end
end