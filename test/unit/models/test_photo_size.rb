require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_PhotoSizes < Test::Unit::TestCase
  context 'Flickr::PhotoSize' do

    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
      @size = @sizes.last
    end

    should 'be correct class' do
      assert_equal @package::PhotoSize,@size.class, 'correct size provided by photo'
    end
    
    should 'give correct id' do
      count=0
      assert_equal '4877807944',@size.id, 'give correct id'
    end

    should 'respond correctly to delegated methods' do
      assert_equal 'Large',@size.label,'gives correct photo label'
      assert_equal '683',@size.width,'gives correct width'
      assert_equal '1024',@size.height,'gives correct height'
      assert_equal 'http://farm5.static.flickr.com/4141/4877807944_0233b81a92_b.jpg',@size.source,'gives correct source'
      assert_equal 'http://www.flickr.com/photos/artandexpeditions/4877807944/sizes/l/',@size.url, 'gives correct url'
      assert_equal 'photo',@size.media,'correct media'
    end

  end

end
