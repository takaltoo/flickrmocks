require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_PhotoSizes < Test::Unit::TestCase
  context 'non-delegated methods' do
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
  end

  context 'delegated methods' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
      @size = @sizes.last
    end
    # check a few options to ensure it works properly
    should 'respond correctly to :label' do
      assert_equal 'Large',@size.label,'gives correct photo label'
    end
    should 'respond to :media' do
      assert_equal 'photo',@size.media,'correct media'
    end
  end

end
