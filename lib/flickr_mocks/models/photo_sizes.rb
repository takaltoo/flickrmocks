module FlickrMocks
  class PhotoSizes

    def initialize(object)
      raise TypeError, 'FlickRaw::Response expected' unless object.class == FlickRaw::ResponseList
      self.delegated_to_object= object
    end

    def id
      @delegated_to_object.first.id
    end

    def secret
      @delegated_to_object.first.secret
    end

    def sizes
      @delegated_to_object
    end

    def available_sizes
      @available_sizes ||= sizes.map do |size|
        size.size.to_sym
      end
      @available_sizes
    end

    def collection
      @collection ||= ::WillPaginate::Collection.create(1, sizes.length, sizes.length) do |obj|
        obj.replace(sizes)
      end
      @collection
    end


    def to_s
      PhotoDimensions.new(@delegated_to_object.map do |size|
          "#{size.size}:#{size.width}x#{size.height}"
        end.join(',')).to_s
    end

    def ==(other)
      return false unless self.class == other.class
      @delegated_to_object == other.instance_eval('@delegated_to_object')
    end

    def possible_sizes
      Models::Helpers.possible_sizes
    end

    # metaprogramming methods
    alias :old_methods :methods
    def methods
      delegated_instance_methods + old_methods
    end

    def method_missing(id,*args,&block)
      return @delegated_to_object.send(id,*args,&block) if  delegated_instance_methods.include?(id)
      return nil if possible_sizes.include?(name)
      super
    end

    alias :old_respond_to? :respond_to?
    def respond_to?(method)
      old_respond_to?(method) || delegated_instance_methods.include?(method)
    end

    def delegated_instance_methods
      possible_sizes + FlickrMocks::Models::Helpers.array_accessor_methods
    end

    # cloning methods
    def initialize_copy(orig)
      super
      @delegated_to_object = @delegated_to_object.map do |data|
        data.clone
      end
    end


    private

    def delegated_to_object=(data)
      @delegated_to_object = []
      data.each do |datum|
        @delegated_to_object.push PhotoSize.new datum
      end
    end
    

  end
end

