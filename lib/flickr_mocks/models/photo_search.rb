module FlickrMocks
  module Models
    class PhotoSearch
      attr_reader :search_terms,:page,:date

      @defaults =  {
        :page => 1
      }
    
      @delegated_instance_methods = [:current_page, :per_page, :total_entries, :capped_entries,:perpage, :capped?,
        :max_entries, :collection]

      class << self
        attr_accessor :defaults
        attr_accessor :delegated_instance_methods
      end

      def initialize(data,options={})
        self.delegated_to_object = data
        self.search_terms = extract_search_terms(options)
        self.page = extract_page(options)
        self.date = extract_date(options)
      end


      # returns the string stored in the :search_terms tag. The string is stripped
      # of spurious spaces and is made to be lower case.
      def extract_search_terms(params)
        Api::Sanitize.tags(params[:search_terms])
      end

      def extract_date(params)
        date = params[:date]
        case date
        when NilClass
          nil
        when String
          Api::Helpers.valid_date?(date) ? Api::Helpers.date(date) : raise(ArgumentError)
        else
          raise ArgumentError
        end
      end

      def extract_page(params)
        Api::Sanitize.page(params[:page])
      end

      # returns the default class instance value corresponding to the supplied key.
      def default(value)
        PhotoSearch.defaults[value.to_sym]
      end

      # returns the list of photo objects returned by search
      def photos
        @delegated_to_object
      end
    
      def total_results
        total_entries
      end

      def url_params
        { :search_terms => search_terms,
          :date => (date.nil? && search_terms.empty?) ? Api::Helpers.date : date
        }.keep_if do |k,v|  !(v.nil? || v.to_s.empty?) end
      end

      def ==(other)
        return false unless other.class == self.class
        (photos == other.photos) && [:search_terms,:page,:date].inject(true) do |state,method|
          state && (self.send(method) == other.send(method))
        end
      end

      # metaprogramming methods
      def method_missing(id,*args,&block)
        return photos.photos.send(id,*args,&block)  if delegated_array_accessor_methods.include?(id)
        return photos.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      def respond_to?(method)
        delegated_instance_methods.include?(method) || old_respond_to?(method)
      end

      alias :old_methods :methods
      def methods
        delegated_instance_methods  + old_methods
      end

      def delegated_instance_methods
        PhotoSearch.delegated_instance_methods + delegated_array_accessor_methods
      end


      # custom cloning methods
      def initialize_copy(other)
        super
        @delegated_to_object = @delegated_to_object.clone
      end

      private

      def delegated_to_object=(data)
        @delegated_to_object = case data
        when FlickRaw::ResponseList then Photos.new(data)
        when Photos then data
        else raise ArgumentError, "expecting object of class Photos or FlickRaw::ResponseList"
        end
      
      end

      def search_terms=(terms=nil)
        terms ||= ''
        raise ArgumentError, "Expecting String but got #{terms.class}" unless terms.is_a?(String)
        @search_terms = terms
      end

      def page=(page=nil)
        page ||= default(:page)
        raise ArgumentError, "Expecting Fixnum but got #{page.class}" unless page.is_a?(Fixnum) or page.is_a?(String)
        @page = page.to_i
      end

      def date=(date=nil)
        raise ArgumentError, "Expecting String but got #{date.class}" unless date.is_a?(String) or date.nil?
        begin
          Chronic.parse(date) unless date.nil?
        rescue
          raise ArgumentError, "#{date} string can not be converted to Time object"
        end
        @date = date
      end

      def delegated_array_accessor_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end
    
    end
  end
end