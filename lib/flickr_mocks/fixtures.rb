
module FlickrMocks
  class Fixtures
    attr_accessor :photo_details,:photos,:photo,:photo_sizes,:interesting_photos,:author_photos

    def initialize
      @photo_details = load_fixture(:photo_details)
      @photos = load_fixture(:photos)
      @photo = @photos[0]
      @photo_sizes = load_fixture(:photo_sizes)
      @interesting_photos = load_fixture(:interesting_photos)
      @author_photos = load_fixture(:author_photos)
    end

    def self.repository
      File.expand_path(File.dirname(__FILE__) + '/../../test/fixtures') + '/'
    end

    private
    def load_fixture(file)
      fname = Fixtures.repository + file.to_s + '.marshal'
      FlickrMocks::Helpers.load fname
    end

  end
end
