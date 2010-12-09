module FlickrMocks
  class PhotoDetails
    attr_reader :dimensions
    
    def initialize(photo,dimensions)
      self.dimensions = dimensions
      self.delegated_to_object=  photo
      raise ArgumentError 'owner id for photo did not match owner id for at least one size' unless valid_owner_for_dimensions?
    end

    def author
      owner_name.empty? ? owner_username : owner_name
    end

    def owner_name
      self.owner.realname
    end
    
    def owner_username
      self.owner.username
    end
    
    def dimensions
      @dimensions
    end

    def photo
      @delegated_to_object
    end

    def possible_sizes
      FlickrMocks::Models::Helpers.possible_sizes
    end

    def ==(other)
      return false unless other.class == PhotoDetails
      (dimensions == other.dimensions) && (@delegated_to_object == other.instance_eval('@delegated_to_object'))
    end

    # metaprogramming methods
    def method_missing(id,*args,&block)
      return dimensions.sizes.send(id,*args,&block) if array_accessor_methods.include?(id)
      return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
      super
    end

    alias :old_respond_to? :respond_to?
    def respond_to?(method,type=false)
      delegated_instance_methods.include?(method) || old_respond_to?(method)
    end

    alias :old_methods :methods
    def methods
      delegated_instance_methods + old_methods
    end

    def delegated_instance_methods
      @delegated_to_object.delegated_instance_methods + array_accessor_methods + [:owner_id] + possible_sizes
    end

    # custom cloning methods
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