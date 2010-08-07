module FlickrMocks

  module CustomMarshal

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def _load(string)
        data = Marshal.load(string)
        type = data.delete('flickr_type')
          FlickRaw::Response.build(data,type)
      end
    end

    def _dump(level)
      result = FlickrMocks::Helpers.marshal_flickraw(self)
      result["flickr_type"] = self.flickr_type
      Marshal.dump result
    end

    

  end
end
