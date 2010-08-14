require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_Fixtures < Test::Unit::TestCase
  context 'FlickrMocks::Fixtures' do
    setup do
      @f = FlickrMocks::Fixtures.new
    end

    should 'be able to access :photos' do
      assert_equal FlickRaw::ResponseList,@f.photos.class, ':photos can be accessed'
      assert @f.photos[0].respond_to?(:id),'elements respond to id'
    end

    should 'be able to access :photo_details' do
      assert_equal FlickRaw::Response,@f.photo_details.class, ':photo_details can be accessed'
      assert @f.photo_details.respond_to?(:dateuploaded), 'element responds to :dateuploaded'
    end

    should 'be able to access :photo' do
      assert_equal FlickRaw::Response,@f.photo.class, ':photo can be accessed'
      assert @f.photo.respond_to?(:owner), 'element responds to :owner'
    end

    should 'be able to access :photo_sizes' do
      assert_equal FlickRaw::ResponseList,@f.photo_sizes.class, ':photo_sizes can be accessed'
      assert @f.photo_sizes[0].respond_to?(:label), 'element responds to :label'
    end

    should 'be able to access :interesting_photos' do
      assert_equal FlickRaw::ResponseList,@f.interesting_photos.class, ':interesting_photos can be accessed'
      assert @f.interesting_photos.respond_to?(:perpage), 'element responds to :perpage'
    end

    should 'provide correct self.repository' do
      expected = File.expand_path(File.dirname(__FILE__) + '/../fixtures') + '/'
      assert_equal expected,FlickrMocks::Fixtures.repository,'self.repository is properly provided'
    end

  end
end