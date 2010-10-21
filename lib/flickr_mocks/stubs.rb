module FlickrMocks
  module Stubs

    def self.stub_flickr
      [:stub_search,:stub_getInfo,:stub_getSizes,:stub_interestingness].each do |method|
        self.send(method)
      end
    end


    def self.stub_search
      fixtures = Fixtures.new
      Proc.new { flickr.photos.stub(:search) do |params|
          if !params.is_a?(Hash)
            fixtures.photos
          elsif params.has_key?(:tags)
            fixtures.photos
          elsif params.has_key?(:user_id)
            fixtures.author_photos
          else
            fixtures.photos
          end
        end
      }.call
    end

    def self.stub_getInfo
      Proc.new { 
        flickr.photos.stub(:getInfo).and_return(Fixtures.new.photo_details)
      }.call
    end

    def self.stub_getSizes
      Proc.new { 
        flickr.photos.stub(:getSizes).and_return(Fixtures.new.photo_sizes)
      }.call
    end

    def self.stub_interestingness
      Proc.new { 
        flickr.interestingness.stub(:getList).and_return(Fixtures.new.interesting_photos)
      }.call
    end

  end
end









