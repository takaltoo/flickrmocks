module FlickrMocks

  # module is included in classes that wrap the FlickRaw::Response and FlickRaw::ResponseList
  # objects. Module is used internally.
  module CustomClone
    # special ruby method that overrides Ruby's cloning method. 
    def initialize_copy(orig)
      super
      cloned = @h.clone
      @h = cloned.each_pair do |key,value|
        case value
        when Fixnum then next
        when String then cloned[key] = value.clone
        when Array then cloned[key] = value.clone.map do |elem| elem.clone end
        when FlickRaw::Response then cloned[key] = value.clone
        end
      end
    end
  end

end
