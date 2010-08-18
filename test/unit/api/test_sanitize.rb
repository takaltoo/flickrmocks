require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_ApiSanitize < Test::Unit::TestCase
  context 'self.sanitize_tags' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
    end
    should 'give correct tags with baseline options' do
      assert_equal 'iran,shiraz',@c.sanitize_tags('iran,shiraz'),'gives correct search terms'
    end
    should 'properly make tags lower case' do
      assert_equal 'iran,shiraz',@c.sanitize_tags('iran,shiraz'),'properly lower cases tags'
    end
    should 'properly strip spaces from tags' do
      assert_equal 'iran,shiraz',@c.sanitize_tags('iran ,   shiraz  '),'properly stripped spaces from tags'
    end
    should 'properly preserve tags with spaces' do
      assert_equal 'iran,shiraz hafez,isfehan',@c.sanitize_tags('iran  ,       shiraz hafez,  isfehan'),'properly preserves tags with spaces'
    end
  end

  context 'self.sanitize_per_page should behve properly' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @pp = {}
    end
    should 'give proper tags with default :per_page' do
      assert_equal '2',@c.sanitize_per_page(@pp.clone.merge({:per_page => '2'})),':per_page gives proper'
    end
    should 'give proper :per_page without specification' do
      assert_equal '200',@c.sanitize_per_page(@pp),'gives proper value without specifying :per_page'
    end
    should 'give preference to :per_page over :perpage' do
      assert_equal '222',@c.sanitize_per_page(@pp.clone.merge({:per_page=>'222',:perpage=>'333'}))
    end
  end

  context 'self.sanitize_page' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @p = {}
    end
    should 'give page number if specified' do
      assert_equal '2',@c.sanitize_page(@p.merge({:page => 2})), 'default values are properly given'
    end
    should 'give correct page if non specified' do
      assert_equal '1',@c.sanitize_page(@p),'correct value if none specified'
    end
    should 'give correct page if "0"' do
      assert_equal '1',@c.sanitize_page(@p.clone.merge({:page => "0"})), 'gives correct value if "0"'
    end
    should 'give correct page if 0' do
      assert_equal '1',@c.sanitize_page(@p.clone.merge({:page => 0})), 'gives correct value if 0'
    end
  end

  context 'self.sanitize_tag_mode' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @tm ={}
    end
    should 'return default tag_mode if none specified' do
      assert_equal 'any',@c.sanitize_tag_mode()
    end
    should 'return default tag_mode if junk specified' do
      assert_equal 'any',@c.sanitize_tag_mode({:tag_mode => 'junk'})
    end
    should 'return default if nil' do
      assert_equal 'any',@c.sanitize_tag_mode({:tag_mode => nil})
    end
    should 'return all if specified' do
      assert_equal 'all',@c.sanitize_tag_mode({:tag_mode => 'all'})
    end
  end


  context 'self.sanitize_time' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @t = {}
    end

    should 'give correct Time with default values' do
      assert_equal '2010-12-22',@c.sanitize_time(@t.merge(:date => '2010-12-22')), 'basic time is given correctly'
    end
    should 'give correct date if Time specified' do
      date = Chronic.parse('Jan 1 2003').strftime('%Y-%m-%d')
      assert_equal date,@c.sanitize_time(@t.merge({:date => 'Jan 1 2003'}))
    end

    should 'give yesterday if no time specified' do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal date, @c.sanitize_time(@t),'yesterday returned if none specified'
    end
  end


end
