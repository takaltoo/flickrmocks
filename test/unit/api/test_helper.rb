require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_ApiHelper < Test::Unit::TestCase
    context 'self.default' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @t = {}
    end
    should 'give proper value with string key' do
      assert_equal @c.defaults[:per_page],@c.default('per_page'), 'correct values if string specified'
    end
    should 'give proper value with symbol key' do
       assert_equal @c.defaults[:per_page],@c.default(:per_page), 'correct values if string specified'
    end
  end

  context 'self.size' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
    end
    should 'give proper size with symbol' do
      assert_equal :small,@c.size({:size => 'small'}),'symbol properly given'
    end
    should 'give proper size when string' do
      assert_equal :'medium 640',@c.size({:size => 'medium 640'}),'string properly returned'
    end
    should 'downcase passed in value' do
      assert_equal :hello, @c.size({:size => 'HeLlO'}),'string properly downcased'
    end
    should 'give nil if no size given' do
      assert_equal nil,@c.size(),'nil properly returned'
    end
  end
end
