module FlickrMocks

  # contains custom methods that allow the marshaling of FlickRaw::Response and
  # FlickRaw::ResponseList objects. FlickRaw responses contain singleton methods that
  # can not be marshaled by default. This module is used internally
  module CustomMarshal

    def self.included(base) 
      base.extend ClassMethods
    end
    
    module ClassMethods    
      # used to un-marshal FlickRaw responses
      def _load(string)
        data = Marshal.load(string)
        type = data.delete('flickr_type')
        FlickRaw::Response.build(data,type)
      end
    end

    # used to marshal FlickRaw responses
    def _dump(level)
      result = marshal_flickraw(self)
      result["flickr_type"] = self.flickr_type
      Marshal.dump result
    end

    private
    def marshal_flickraw(obj)
      r = {}
      obj.methods(false).each do |k|
        v = obj.send k.to_sym
        r[k.to_s] = case v
        when Array then v.collect {|e| marshal_flickraw(e)}
        when FlickRaw::Response then marshal_flickraw(v)
        when FlickRaw::ResponseList then marshal_flickraw(v)
        else v
        end
      end
      r
    end

  end
end
