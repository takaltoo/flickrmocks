module FlickrMocks
  module Models
    class PhotoSearch
      attr_reader :search_terms,:page,:date

      @delegated_instance_methods = [:current_page, :per_page, :total_entries, :capped_entries,:perpage, :capped?,
        :max_entries, :collection]

      class << self
        attr_accessor :delegated_instance_methods
      end

      def initialize(data,options={})
        self.delegated_to_object = data
        @search_terms = extract_search_terms(options)
        @page = extract_page(options).to_i
        @date = extract_date(options)
      end


      # returns the string stored in the :search_terms key for the supplied 
      # options hash.
      # The string is stripped of non-required spaces and is made to be lower case.
      # Sample usage:
      #
      #  extract_search_terms(:search_terms => 'Lyon , France'  --> 'lyon,france'
      def extract_search_terms(options)
        Api::Sanitize.tags(options[:search_terms])
      end

      # returns the date stored in the :date key for the supplied options hash.
      # Values other than nil and strings of format 'YYYY-MM-DD' will raise an
      # argument error. Sample usage:
      #
      #  extract_date(:date => '2010-10-10')    --> '2010-10-10'
      def extract_date(options)
        date = options[:date]
        case date
        when NilClass
          nil
        when String
          Api::Helpers.valid_date?(date) ? Api::Helpers.date(date) : raise(ArgumentError)
        else
          raise ArgumentError
        end
      end

      # returns the sanitized version of the value stored in the :page key for the
      # supplied options hash. 
      def extract_page(options)
        Api::Sanitize.page(options[:page])
      end


      # returns Photos object that contains information regarding the photos returned
      # from Flickr
      def photos
        @delegated_to_object
      end

      # returns the total number of results available from Flickr for the given photo.
      # note flickr only returns 4,000 maximum for a given query.
      def total_results
        total_entries
      end

      # returns hash of parameters that were used for performing the query.
      def url_params
        { :search_terms => search_terms,
          :date => (date.nil? && (search_terms.nil? || search_terms.empty?)) ? Api::Helpers.date : date
        }.keep_if do |k,v|  !(v.nil? || v.to_s.empty?) end
      end

      # compares the complete internal state of two PhotoDetails objects rather than simply
      # comparing object_id's
      def ==(other)
        return false unless other.class == self.class
        (photos == other.photos) && [:search_terms,:page,:date].inject(true) do |state,method|
          state && (self.send(method) == other.send(method))
        end
      end

      # metaprogramming methods

      # delegates methods that are returned by delegated instance method. It also
      # delegates array methods to the @dimensions object
      def method_missing(id,*args,&block)
        return photos.photos.send(id,*args,&block)  if delegated_array_accessor_methods.include?(id)
        return photos.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      # returns true for delegated and regular methods
      def respond_to?(method)
        delegated_instance_methods.include?(method) || old_respond_to?(method)
      end

      alias :old_methods :methods
      # returns delegated methods as well as regular methods
      def methods
        delegated_instance_methods  + old_methods
      end

      # returns list of methods that are delegated to other objects
      def delegated_instance_methods
        PhotoSearch.delegated_instance_methods + delegated_array_accessor_methods
      end


      # compares value for internal state rather than object_id
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

      def delegated_array_accessor_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end
    
    end
  end
end