module FlickrMocks

  # module that contains methods that contain custom '==' check. This module is
  # used internally and is included in the FlickrMocks::Models.
  module CustomCompare
    # custom equality method that is added in various classes to override Ruby's default
    # '==' behavior
    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(self.class)
      case other
      when FlickRaw::Response then compare_response(other)
      else self == other
      end
    end

    private
    def compare_response(other)
      self.methods(false).map do |method|
        return false unless other.respond_to?(method)
        self.send(method) == other.send(method)
      end.inject(true) do |previous,current|
        previous && current
      end
    end


  end
end