require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_ModelsPagesWithUrl < Test::Unit::TestCase
  context ':page' do
    setup do
        @package = FlickrMocks
        @pages = FlickrMocks::Pages
    end
    should 'give correct page when string' do
      assert_equal 2,@pages.new(:page => '2').page, 'string converted to integer'
    end
    should 'give correct page when integer' do
      assert_equal 3,@pages.new(:page=>3).page,'integer passed in properly'
    end
  end

  context ':url' do
     setup do
        @package = FlickrMocks
        @pages = FlickrMocks::Pages
    end
    should 'properly access url' do
      assert_equal 'http://www.happy.com/',@pages.new(:url=> 'http://www.happy.com/').url,'url passed in properly'
    end
  end

  context ':current_page' do
     setup do
        @package = FlickrMocks
        @pages = FlickrMocks::Pages
    end
    should 'properly pass in :current_page when string' do
      assert_equal 3,@pages.new(:current_page => '3').current_page
    end
    should 'properly pass in :current_page when integer' do
      assert_equal 4,@pages.new(:current_page => 4).current_page
    end
  end

  context 'current_page?' do
    setup do
      @package = FlickrMocks
      @pages = FlickrMocks::Pages
    end
    should 'detect whether page is the same as current_page' do
      assert @pages.new(:current_page => 3,:page =>3).current_page?
    end
    should 'detect whether a page is NOT the same as current_page' do
      assert !@pages.new(:current_page => 3, :page => 4).current_page?
    end
  end
end
