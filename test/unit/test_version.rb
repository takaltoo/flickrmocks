require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_Version < Test::Unit::TestCase
  context 'FlickrMocks::VERSION' do
    should 'provide correct VERSION' do
      version = File.read(File.expand_path("../../../VERSION", __FILE__)).strip
      assert_equal version,FlickrMocks::VERSION,'proper VERSION given'
    end

  end
end
