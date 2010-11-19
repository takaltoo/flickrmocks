
module FlickrMocks
  class CommonsInstitution
    def initialize(object)
      self.delegated_to_object = object
    end
    
    def launch_date
      @delegated_to_object.date_launch
    end

    def owner_id
      @delegated_to_object.nsid
    end
    alias :owner :owner_id

    def owner_name
      @delegated_to_object.name
    end

    def  flickr_url
      get_url(:flickr)
    end

    def site_url
      get_url(:site)
    end
    
    def license_url
      get_url(:license)
    end

    def ==(other)
      @delegated_to_object == other.instance_eval('@delegated_to_object')
    end

    def initialize_copy(orig)
      super
      @delegated_to_object = @delegated_to_object.clone
    end
    
    private
      def delegated_to_object=(object)
        raise ArgumentError, "Expected object of class FlickRaw::Response but received #{object.class}" unless object.class == FlickRaw::Response
        @delegated_to_object = object
      end

      def get_url(type)
        @delegated_to_object.urls[get_url_index(type)]['_content']
      end

      def get_url_index(type)
        @delegated_to_object.urls.map do |url| url['type'].to_sym end.find_index(type.to_sym)
      end
  end
end
