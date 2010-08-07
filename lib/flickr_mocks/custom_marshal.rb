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
      result = _marshal_object(self)
      result["flickr_type"] = self.flickr_type
      Marshal.dump result
    end

    private

    def _marshal_object(obj)
      r = {}
      obj.methods(false).each do |k|
        v = obj.send k.to_sym
        r[k.to_s] = case v
        when Array then v.collect {|e| _marshal_object(e)}
        when FlickRaw::Response then _marshal_object(v)
        when FlickRaw::ResponseList then _marshal_object(v)
        else v
        end
      end
      r
    end
  end
end
