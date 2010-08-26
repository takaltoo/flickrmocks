require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_ApiTest < Test::Unit::TestCase
  context 'self :defaults' do
    setup do
      @package = FlickrMocks
    end

    should 'be able to access @defaults' do

      defaults =  @package::Api.defaults.clone
      assert_equal [:per_page,:license,:media,:extras,:tag_mode,:flickr_tag_modes].sort,@package::Api.defaults.keys.sort, 'valid keys are present'
      @package::Api.defaults[:per_page]=20
      assert_equal 20,@package::Api.defaults[:per_page],'can set default per_page'
      @package::Api.defaults = defaults
      assert_equal defaults,@package::Api.defaults, 'can set the defaults'
    end

  end
  context 'self.search' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
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
  end

  context 'self.photos' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo =  fixtures.photo_details
    end
    should 'be able to get information for a photo' do
      flickr.photos.stubs(:getInfo).returns(@photo)
      info = @package::Api.photo({:photo=>'4877807944',:secret => '0233b81a92'})

      assert_equal @package::Photo, info.class,'sizes are properly passed in'
      assert_equal '4877807944',info.id, 'id is properly set'
      assert_equal '0233b81a92',info.secret, 'secret is  properly passed in'
    end
  end

  context 'self.photo_sizes' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes =  fixtures.photo_sizes
    end

    should 'be able to get information about sizes for photos' do
      flickr.photos.stubs(:getSizes).returns(@sizes)
      sizes = @package::Api.photo_sizes({:photo=>'4877807944',:secret => '0233b81a92'})

      assert_equal @package::PhotoSizes,sizes.class, 'properly returned sizes'
      assert_equal '4877807944',sizes[0].id
    end
  end

  context 'self.photo_details' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = fixtures.photo_details
      @sizes = fixtures.photo_sizes
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
  end

  context 'self.interesting_photos' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @interesting = fixtures.interesting_photos
    end

    should 'be able to get interesting photos' do
      flickr.interestingness.stubs(:getList).returns(@interesting)
      photos = @package::Api.interesting_photos({:date =>'2010-07-10',:base_url => 'http://www.happydays.com/'})
      
      assert_equal @package::Photos,photos.class,'proper classs returned'
      assert_equal '2010-07-10',photos.date,'properly passed in search terms'
      assert_equal  'http://www.happydays.com/' + '?date=2010-07-10&page=1', photos.search_url,'base_url option properly passed in'
    end
  end
  
  context 'self.author_photos' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @author_photos = fixtures.author_photos
    end

    should 'be able to get author photos' do
      flickr.photos.stubs(:search).returns(@author_photos)
      photos = @package::Api.author_photos({:search_author_terms =>'121313@N00',:base_url => 'http://www.happydays.com/'})

      assert_equal @package::Photos,photos.class,'proper classs returned'
      assert_equal photos[0].owner,photos[1].owner,'phot os belong to same author'
    end
  end

  
end


