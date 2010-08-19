module FlickrMocks

  class Pages
    attr_reader :current_page,:page,:url

    def initialize(options=nil)
      self.current_page = options[:current_page].to_i
      self.page = options[:page].to_i
      self.url = options[:url]
    end

    def current_page?
      @current_page == @page
    end

    private
    attr_writer :current_page,:url,:page
  end

end