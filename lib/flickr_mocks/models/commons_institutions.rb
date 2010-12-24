
module FlickrMocks
  module Models
    class CommonsInstitutions
      attr_accessor :per_page,:current_page

      @defaults =  FlickrMocks::Models::Helpers.paging_defaults.clone

      class << self
        attr_accessor :defaults
      end

      def initialize(institutions,options={})
        self.delegated_to_object = institutions
        self.per_page = extract_per_page(options)
        self.current_page = extract_current_page(options)
      end
      
      def  extract_per_page(params)
        Api::Sanitize.per_page_hash(params)
      end

      def extract_current_page(params)
        Api::Sanitize.page(params[:current_page] || params[:page])
      end

      def default(value)
        CommonsInstitutions.defaults[value.to_s.to_sym]
      end

      def ==(other)
        per_page == other.per_page and
          current_page == other.current_page and
          @delegated_to_object == other.instance_eval('@delegated_to_object')
      end

      def initialize_copy(orig)
        super
        @delegated_to_object = @delegated_to_object.clone
      end

      def delegated_instance_methods
        FlickrMocks::Models::Helpers.array_accessor_methods
      end

      def method_missing(id,*args,&block)
        return @delegated_to_object.send(id,*args,&block) if delegated_instance_methods.include?(id)
        super
      end

      alias :old_respond_to? :respond_to?
      def respond_to?(method,type=false)
        return true if delegated_instance_methods.include?(method)
        old_respond_to?(method,type)
      end

      alias :old_methods :methods
      def methods
        delegated_instance_methods + old_methods
      end

      # custom cloning methods
      def initialize_copy(orig)
        super
        @delegated_to_object = @delegated_to_object.map do |institution|
          institution.clone
        end
      end

      def total_entries
        @delegated_to_object.size
      end

      def institutions
        @delegated_to_object
      end

      def collection
        ::WillPaginate::Collection.create(current_page, per_page, total_entries) do |obj|
          start = (current_page-1)*per_page
          obj.replace(institutions[start, per_page])
        end
      end

      private
      def delegated_to_object=(object)
        raise ArgumentError, "FlickRaw::ResponseList expected" unless object.class == FlickRaw::ResponseList
        @delegated_to_object = object.institution
      end

      def per_page=(value)
        @per_page = value.to_i == 0 ? default(:per_page) : value.to_i
      end

      def current_page=(page)
        @current_page = Api::Sanitize.page(page).to_i > max_page ? max_page : Api::Sanitize.page(page).to_i
      end

      def max_page
        (total_entries  / @per_page.to_f).ceil == 0 ? 1 : (total_entries  / @per_page.to_f).ceil
      end
    end
  end
end