module FlickrMocks
  class PhotoSize
    @delegated_methods = [:label, :width, :height, :source, :url, :media, :flickr_type]
    class<< self
      attr_accessor :delegated_methods
    end
    def initialize(size)
      raise TypeError, 'FlickRaw::Response expected' unless size.is_a? FlickRaw::Response
      @__delegated_to_object__= size
    end

    def size
      label.to_s.downcase.sub(/\s+/,'_')
    end

    def id
      source.split('/')[-1].split('_')[0]
    end

    def secret
      source.split('/')[-1].split('_')[1]
    end

    def method_missing(id,*args,&block)
      return @__delegated_to_object__.send(id,*args,&block) if PhotoSize.delegated_methods.include?(id)
      super
    end

    def respond_to?(method,type=false)
      return true if PhotoSize.delegated_methods.include?(method)
      super
    end

    def methods
      PhotoSize.delegated_methods + super
    end

    def public_methods(all=true)
      PhotoSize.delegated_methods + super(all)
    end
  end

end