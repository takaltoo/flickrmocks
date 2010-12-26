
module FlickrMocks
  module Models
    class CommonsInstitution
      def initialize(object)
        self.delegated_to_object = object
      end

      # returns the launch date for the commons institution
      def launch_date
        @delegated_to_object.date_launch
      end

      # returns the Owner id for the commons institution
      def owner_id
        @delegated_to_object.nsid
      end
      alias :owner :owner_id

      # returns name of the commons institution
      def owner_name
        @delegated_to_object.name
      end

      # returns flickr web address for the institution
      def  flickr_url
        get_url(:flickr)
      end

      # returns external web address for the institution
      def site_url
        get_url(:site)
      end

      # returns the url that describes the licensing
      def license_url
        get_url(:license)
      end

      # returns true if supplied object is equivalent to self
      def ==(other)
        @delegated_to_object == other.instance_eval('@delegated_to_object')
      end

      # customizes the cloning behavior of the object. Internal state of cloned object
      # will not point to original object. 
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
end
