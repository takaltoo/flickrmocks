require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_ApiTest < Test::Unit::TestCase
  context 'FlickrMocks::Api' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      @photo =  fixtures.photo_details
      @sizes =  fixtures.photo_sizes
      @interesting = fixtures.interesting_photos
    end

    should 'be able to access @defaults' do

      defaults =  @package::Api.defaults.clone
      assert_equal [:per_page,:license,:media,:extras,:tag_mode,:flickr_tag_modes].sort,@package::Api.defaults.keys.sort, 'valid keys are present'
      @package::Api.defaults[:per_page]=20
      assert_equal 20,@package::Api.defaults[:per_page],'can set default per_page'
      @package::Api.defaults = defaults
      assert_equal defaults,@package::Api.defaults, 'can set the defaults'
    end

    should 'be able to search for photos' do
      flickr.photos.stubs(:search).returns(@photos)
      search_terms = {:search_terms=>'iran'}
      base_url = 'http://www.happydays.com/'
      photos = @package::Api.photos({:per_page=>'5',:search_terms=>'iran',:base_url=>base_url})

      assert_equal @package::Photos,photos.class,'proper class generated'
      assert_equal 'iran',photos.search_terms,'properly passed in search terms'
      assert_equal base_url + '?page=1&search_terms=iran', photos.search_url,'base_url option properly passed in'
    end

    should 'be able to get information for a photo' do
      flickr.photos.stubs(:getInfo).returns(@photo)
      info = @package::Api.photo({:photo=>'4877807944',:secret => '0233b81a92'})

      assert_equal @package::Photo, info.class,'sizes are properly passed in'
      assert_equal '4877807944',info.id, 'id is properly set'
      assert_equal '0233b81a92',info.secret, 'secret is  properly passed in'
    end

    should 'be able to get information about sizes for photos' do
      flickr.photos.stubs(:getSizes).returns(@sizes)
      sizes = @package::Api.photo_sizes({:photo=>'4877807944',:secret => '0233b81a92'})

      assert_equal @package::PhotoSizes,sizes.class, 'properly returned sizes'
      assert_equal '4877807944',sizes[0].id
    end

    should 'be able to get details for photos' do
      flickr.photos.stubs(:getSizes).returns(@sizes)
      flickr.photos.stubs(:getInfo).returns(@photo)
      
      details = @package::Api.photo_details({:photo=>'4877807944',:secret => '0233b81a92'})

      assert_equal @package::PhotoDetails,details.class,'proper class returned'
      assert_equal @package::PhotoSizes,details.sizes.class,'sizes class returned'
      assert_equal "4877807944",details.id,'proper id returned'
      assert_equal details.id,details.sizes[0].id,'proper id returnedf'
    end

    should 'be able to get interesting photos' do
      flickr.interestingness.stubs(:getList).returns(@interesting)
      photos = @package::Api.interesting_photos({:date =>'2010-07-10',:base_url => 'http://www.happydays.com/'})
      
      assert_equal @package::Photos,photos.class,'proper classs returned'
      assert_equal '2010-07-10',photos.date,'properly passed in search terms'
      assert_equal  'http://www.happydays.com/' + '?date=2010-07-10&page=1', photos.search_url,'base_url option properly passed in'
    end

  end

  context 'self :photo_options' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @expected = {:photo_id => '20030', :secret => 'abcdef'}
    end

    should 'extract :photo_id and :secret when present' do
      assert_equal @expected, @c.photo_options( {:photo_id => '20030', :photo_secret => 'abcdef'}),'base case extracted'
    end

    should 'extract :id when present' do
      assert_equal @expected, @c.photo_options({:id => '20030', :photo_secret => 'abcdef'}),':id is extracted when present'
    end

    should 'extract :secret when present' do
      assert_equal @expected, @c.photo_options({:secret => 'abcdef', :id => '20030'}), ':secret is extracted'
    end

    should 'give preference to :photo_id of :id' do
      assert_equal @expected, @c.photo_options({:secret => 'abcdef', :id =>'not correct', :photo_id => '20030'})
    end

    should 'give preference to :photo_secret over :secret' do
      assert_equal @expected,@c.photo_options({:secret => 'not correct', :id => '20030', :photo_secret => 'abcdef'})
    end
  end

  context 'self.search_options ' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @extras = {
        :license => '4,5,6,7',
        :media => 'photos',
        :extras =>  'm_dims',
        :tag_mode => 'any'
      }
      @expected = {
        :per_page => '400',
        :tags => 'iran,shiraz',
        :page => '2'}.merge(@extras.clone)
      @options = {
        :search_terms => 'iran,shiraz',
        :page => '2'
      }.merge(@extras.clone)
    end

    should 'give correct values when all specified' do
      assert_equal @expected, @c.search_options(@options.clone.merge(:per_page => '400'))
    end
    should 'give correct values when :perpage given' do
      assert_equal @expected, @c.search_options(@options.clone.merge({:perpage => '400'}))
    end

    should 'give correct values when no :perpage specified' do
      assert_equal @expected.clone.merge({:per_page => '200'}), @c.search_options(@options)
    end

    should 'give preference for :per_page over :perpage' do
      assert_equal @expected.clone.merge({:per_page => '500'}), @c.search_options(@options.clone.merge({:per_page => '500', :perpage => '20'}))
    end

    should 'should override :tag_mode' do
      assert_equal @expected.clone.merge({:per_page => '500',:tag_mode => 'all'}), @c.search_options(@options.clone.merge({:per_page => '500', :tag_mode=>'all'}))
    end

    should 'should default to any if :tag_mode not specified' do
      assert_equal @expected.clone.merge({:per_page => '500'}), @c.search_options(@options.clone.merge({:per_page => '500', :tag_mode=>'junk'}))
    end


  end

  context 'self.interesting_options' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @expected = {
        :date => '2010-02-14',
        :per_page => '2',
        :page => '2'
      }

    end

    should 'give proper date with default options' do
      assert_equal @expected,@c.interesting_options(@expected), 'gave correct parameters with default hash'
    end
    should 'give proper date with no page' do
      assert_equal @expected.clone.merge({:page => '1'}),@c.interesting_options({:date=> '2010-02-14',:per_page=>'2'})
    end
    should 'give proper date when none specified' do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal date,@c.interesting_options({})[:date],'correct date returned'
    end

  end

  context 'self.search_params' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @expected = {
        :search_terms => 'iran,shiraz',
        :base_url => 'http://www.happyboy.com/'
      }
    end
    should 'behave properly with fully specified options' do
      assert_equal @expected,@c.search_params(@expected),'parameters with defaults behaves correctly'
    end
    should 'filter non-required options' do
      assert_equal @expected,@c.search_params(@expected.clone.merge({:date=>'2010-10-12',:per_page => '2'}))
    end
    should 'properly extract :base_url' do
      assert_equal @expected.clone.merge({:base_url => 'http://www.illusion.com/'}),@c.search_params(@expected.clone.merge({:base_url => 'http://www.illusion.com/'}))
    end
  end

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

  context 'self.page' do
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

  context 'self.time ' do
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
end


