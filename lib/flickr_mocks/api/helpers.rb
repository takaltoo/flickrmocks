module FlickrMocks
  class Api
    # default control values
    def self.default(value)
      Api.defaults[value.to_sym]
    end

    def self.size(params={})
      params[:size] ? params[:size].downcase.to_sym : nil
    end


  end
end
