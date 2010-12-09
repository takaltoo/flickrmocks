require 'ostruct'
require 'singleton'

module FlickrMocks
  class Fixtures
    include Singleton
    attr_accessor :photos,:interesting_photos,:author_photos,:photo,:photo_details,
                      :photo_sizes,:photo_size,:expected_methods,:empty_photos,
                      :commons_institutions,:commons_institution_photos

    def initialize
      @photos = load_fixture(:photos)
      @interesting_photos = load_fixture(:interesting_photos)
      @author_photos = load_fixture(:author_photos)

      @photo = load_fixture(:photo)
      @photo_details= load_fixture(:photo_details)
      
      @photo_sizes = load_fixture(:photo_sizes)
      @photo_size = load_fixture(:photo_size)

      @commons_institutions = load_fixture(:commons_institutions)
      @commons_institution_photos = load_fixture(:commons_institution_photos)

      @empty_photos = load_fixture(:empty_photos)

      @expected_methods = load_fixture(:expected_methods)

    end

    def self.repository
      File.expand_path(File.dirname(__FILE__) + '/../../spec/fixtures') + '/'
    end

    private
    def load_fixture(file)
      fname = Fixtures.repository + file.to_s + '.marshal'
      FlickrMocks::Helpers.load fname
    end

  end
end
