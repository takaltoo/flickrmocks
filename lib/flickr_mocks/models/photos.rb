module FlickrMocks
  module Models
    class Photos
      attr_reader :current_page,:per_page,:total_entries,:total_pages,:photos
      alias :perpage :per_page

    

      class << self
        attr_writer :defaults
        # returns a hash that contains the class defaults. The recognized
        # default values include:
        #
        #  :max_entries
        #  :per_page
        #  :current_page 
        def defaults
          @defaults ||= FlickrMocks::Models::Helpers.paging_defaults().clone
          @defaults
        end
      end

      def initialize(data)
        raise ArgumentError, 'Expecting class of FlickRaw::ResponseList' unless data.class == FlickRaw::ResponseList
        self.current_page= data.page
        self.per_page= data.perpage
        self.total_entries= data.total
        self.total_pages = data.pages
        self.photos =  data.photo
      end

      # returns the default class value for the supplied symbol. 
      def default(value)
        Photos.defaults[value.to_s.to_sym]
      end

      # returns the total number of entries that were returned from Flickr. Flickr
      # caps the total number of returned photos to 4,000.
      def capped_entries
        total_entries > max_entries ? max_entries : total_entries
      end

      # returns true when the number of photos returned by Flickr is less than the total
      # number of photos available on Flickr for the given results.
      def capped?
        max_entries < total_entries ? true : false
      end

      # returns 4,000, the default maximum number of entries returned by Flickr for
      # any given query.
      def max_entries
        default(:max_entries)
      end

      # returns the number of pages that can be retrieved from Flickr for the given
      # query.
      def pages
        max_pages = default(:max_entries)/perpage
        total_pages > max_pages ? max_pages : total_pages
      end

      # returns only the photos with a license that can be used for commercial purposes
      def usable_photos
        photos.clone.keep_if(&:usable?)
      end

      # returns a collection of photos that can be used directly with WillPaginate.
      def collection(usable=nil)
        case usable
        when true
          usable_photos = photos.clone.keep_if(&:usable?)
          ::WillPaginate::Collection.create(1, per_page, usable_photos.length) do |obj|
            obj.replace(usable_photos)
          end
        else
          ::WillPaginate::Collection.create(current_page, per_page, capped_entries) do |obj|
            obj.replace(photos)
          end
        end
      end

      # compares the complete internal state of two PhotoDetails objects rather than simply
      # comparing object_ids
      def ==(other)
        return false unless other.class == Photos
        return false unless [:current_page,:per_page,:total_entries,:total_pages].inject(true) do |state,method|
          state && (self.send(method) == other.send(method))
        end
        other.respond_to?(:photos) ? photos == other.photos : false
      end


      # metaprogramming methods
     
      # delegates methods that are returned by delegated instance method.
      def method_missing(id,*args,&block)
        return photos.send(id,*args,&block) if  delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method)
        old_respond_to?(method) || delegated_instance_methods.include?(method)
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods + old_methods
      end

      # returns true for delegated and regular methods
      def delegated_instance_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end

      # compares value for internal state rather than object_id
      def initialize_copy(orig)
        super
        @photos = @photos.map do |photo|
          photo.clone
        end
      end

      private
      def current_page=(value)
        raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
        @current_page=value.to_i
      end

      def per_page=(value)
        raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
        @per_page=value.to_i
      end

      def total_entries=(value)
        raise ArgumentError,"Expected Fixnum but was #{value.class}"  unless value.is_a?(Fixnum) or value.is_a?(String)
        @total_entries=value.to_i
      end

      def total_pages=(value)
        raise ArgumentError,"Expected Fixnum but was #{value.class}" unless value.is_a?(Fixnum) or value.is_a?(String)
        @total_pages=value.to_i
      end

      def photos=(photos)
        raise ArgumentError,"Expected argument that responds to :each but got class #{photos.class}" unless photos.respond_to?(:each)
        results = []
        photos.each do |photo|
          raise ArgumentError,"Expected FlickRaw::Response but was #{value.class}" unless photo.is_a?(FlickRaw::Response)
          results.push(Models::Photo.new(photo))
        end
        @photos=results
      end
    end
  end
end