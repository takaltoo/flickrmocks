module FlickrMocks
  module Models
    class Photos
      attr_reader :current_page,:per_page,:total_entries,:total_pages,:photos
      alias :perpage :per_page

      @defaults =  FlickrMocks::Models::Helpers.paging_defaults.clone


      class << self
        attr_accessor :defaults
      end

      def initialize(data)
        raise ArgumentError, 'Expecting class of FlickRaw::ResponseList' unless data.class == FlickRaw::ResponseList
        self.current_page= data.page
        self.per_page= data.perpage
        self.total_entries= data.total
        self.total_pages = data.pages
        self.photos =  data.photo
      end

      def default(value)
        Photos.defaults[value.to_s.to_sym]
      end

      def capped_entries
        total_entries > max_entries ? max_entries : total_entries
      end

      def capped?
        max_entries < total_entries ? true : false
      end

      def max_entries
        default(:max_entries)
      end

      def pages
        max_pages = default(:max_entries)/perpage
        total_pages > max_pages ? max_pages : total_pages
      end

      def usable_photos
        photos.clone.keep_if(&:usable?)
      end

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


      def ==(other)
        return false unless other.class == Photos
        return false unless [:current_page,:per_page,:total_entries,:total_pages].inject(true) do |state,method|
          state && (self.send(method) == other.send(method))
        end
        other.respond_to?(:photos) ? photos == other.photos : false
      end


      # metaprogramming methods
      def method_missing(id,*args,&block)
        return photos.send(id,*args,&block) if  delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      def respond_to?(method)
        old_respond_to?(method) || delegated_instance_methods.include?(method)
      end

      alias :old_methods :methods
      def methods
        delegated_instance_methods + old_methods
      end

      def delegated_instance_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end

      # custom cloning methods
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