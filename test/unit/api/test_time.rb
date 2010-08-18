require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_ApiTime < Test::Unit::TestCase
  context 'self.time' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
    end
    should 'give correct time if non specified' do
      expected = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal expected,@c.time(nil)
    end
    should 'give correct if none specified' do
      expected = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal expected,@c.time
    end
    should 'properly use time object if specified' do
      expected  = '2010-12-25'
      assert_equal expected,@c.time(expected)
    end
  end
end
