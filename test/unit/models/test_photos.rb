require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_Photos < Test::Unit::TestCase
  context ':defaults class variable' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
      @interesting = @package::Photos.new fixtures.photos,{:date => '2009-10-02'}
    end

    should 'be able to get/set Flickr::Photos.defaults class instance variable' do
      def check_attribute_write(*attributes)
        attributes.each do |attribute|
          default=@package::Photos.defaults[attribute]
          value = default.is_a?(String) ? default + 'xyz' : default + 121
          @package::Photos.defaults[attribute]=value
          
          assert_equal value,@package::Photos.defaults[attribute],'default attribute: #{attribute} can be set.'
          @package::Photos.defaults[attribute] = default
        end
      end
      # can write attributes
      check_attribute_write :max_entries,:per_page,:base_url
    end

    should 'be able to read :max_entries' do
      assert_equal 4000, @package::Photos.defaults[:max_entries],'can read :max_entries'
    end
    should 'be able to access :per_page' do
      assert_equal 50,@package::Photos.defaults[:per_page],'can read :per_page'
    end
    should 'be able to access :base_url' do
      assert_equal '/flickr/search',@package::Photos.defaults[:base_url],'can read :base_url'
    end

    should 'be able to read current_page' do
      assert_equal 1,@photos.current_page,':current_page properly set'
    end
    should 'be able to access :per_page' do
      assert_equal 5,@photos.per_page,':per_page properly set'
    end
    should 'be able to access :total_entries' do
      assert_equal 276362,@photos.total_entries,':total_entries properly set'
    end
    should 'be able to access :search_terms' do
      assert_equal 'iran',@photos.search_terms,':search_terms properly set'
    end
    should 'be able to access :max_entries' do
      assert_equal 4000, @photos.max_entries,':max_entries properly set'
    end
    should 'be able to access :collection' do
      assert_equal @photos.photos,@photos.collection,':collection is equal to :photos'
    end
    should 'be able to access :date' do
      assert_equal '2009-10-02',@interesting.date,':date is accessible'
    end
  end

  context ':each_page' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'be able to iterate through each page' do
      pages = []
      @photos.each_page do |page| pages.push page end
      range = 1..@photos.total_pages
      reference = range.map {|num| num}
      assert_equal reference,pages,':each_page can be iterated'
    end
  end

  context ':each_photo' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end

    should 'be able to iterate with each_photo' do
      count = 0
      @photos.each_photo do |photo|
        assert photo.is_a?(@package::Photo),":each_photo properly iterates"
        count+=1
      end
      assert_equal @photos.per_page,count
    end
  end

  context ':pages_with_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end

    should 'gives correct :current_page' do
      pages = @photos.pages_with_url
      index = pages.length() -1
      
      assert pages[0].current_page?,":current_page properly set for first page"

      count = 1
      pages[1,index].each do |obj|
        assert !obj.current_page?,"all other pages are non-current page: #{count}"
        count+=1
      end
    end

    should 'give correct :page' do
      count = 1
      @photos.pages_with_url.each do |obj|
        assert_equal count,obj.page,':page properly set'
        count +=1
      end
    end

    should 'give correct :url' do
      count = 1
      @photos.pages_with_url.each do |obj|
        assert_equal @photos.search_url(:page => count),obj.url,':url properly set'
        count +=1
      end
    end
    
  end

  context ':[]' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end

    should 'give correct index with :[0]' do
      assert_equal @photos.collection[0], @photos[0],':[0] works properly'
    end
    should 'give correct :[-1]' do
      assert_equal @photos.collection[-1], @photos[-1],':[-1] works properly'
    end
    should 'give correct :[3]' do
      assert_equal @photos.collection[3], @photos[3],':[3] works properly'
    end
    should 'give correct :first' do
      assert_equal @photos[0],@photos.first,':first works properly'
    end
    should 'give correct :last' do
      assert_equal @photos[-1],@photos.last,':last works properly'
    end
  end


  context ':total_pages' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'give correct :total_pages and :length' do
      assert_equal 800,@photos.total_pages,':total_pages properly set'
    end
  end

  context ':length' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'give correct :length' do
      assert_equal 800,@photos.length,':total_pages properly set'
    end
  end


  context ':search_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'give correct :search_url with default :base_url' do
      default_url = @package::Photos.defaults[:base_url]
      assert_equal '/flickr/search?page=1&search_terms=iran',@photos.search_url,':search_url properly given'
    end
    should 'give correct :search_url with non-default :base_url' do
      default_url = @package::Photos.defaults[:base_url]
      @package::Photos.defaults[:base_url]='/googoo'
      assert_equal '/googoo?page=1&search_terms=iran',@photos.search_url,':search_url properly given'
      @package::Photos.defaults[:base_url]=default_url
    end
  end
  
  context ':next_page' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end

    should 'give correct next page when no page specified' do
      assert_equal 2,@photos.next_page,':next_page given'
    end

    should 'give correct page when page is 0' do
      assert_equal 1,@photos.next_page(:page => 0),'correct when page is 0'
    end

    should 'give correct :next page when  is -1' do
      assert_equal 1,@photos.next_page(:page => -1),':next_page given'
    end

    should 'give correct :next_page when far away from end' do
      assert_equal 3,@photos.next_page(:page => 2),'returned next page'
    end

    should 'give correct :next_page when right before the end' do
      assert_equal 800,@photos.next_page(:page => 799),'returned last index'
    end

    should 'give correct :next_page when right at the end' do
      assert_equal 800,@photos.next_page(:page => 800),'returned last inext'
    end
    should 'give last page if page number is much higher than last page' do
      assert_equal 800,@photos.next_page(:page => 8001),':next_page given'
    end
  end

  context 'prev_page' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'give correct prev_page when no page specified' do
      assert_equal 1,@photos.prev_page,':prev_page nil'
    end
    should 'give correct prev_page when page is below current_page' do
      assert_equal 1,@photos.prev_page(0),':prev_page 0'
    end
    should 'give correct prev_page when page is negative' do
      assert_equal 1,@photos.prev_page(-1),':prev_page negative'
    end
    should 'give correct prev_page when page is not first' do
      assert_equal 1,@photos.prev_page(2),':prev_page not first'
    end
    should 'give correct prev_page when page is at max page' do
      assert_equal 799,@photos.prev_page(800),':prev_page max_page'
    end
    should 'give correct page when page is one more than max' do
      assert_equal 800,@photos.prev_page(801),':prev_page max_page+=1'
    end
    should 'give correct page when page is much larger than max_page' do
      assert_equal 800, @photos.prev_page(90000),':prev_page much much greater than max_page'
    end
  end

  context ':capped?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new fixtures.photos,{:search_terms => 'iran'}
    end
    should 'give correct capped? value' do
      assert @photos.capped?,':capped? is correct'
    end
  end
  
  context ':search_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      options =  {:search_terms => 'iran,shiraz',:date => '2010-10-04'}
      @data = @package::Photos.new @photos,options
    end

    should 'give :search_terms when all options present' do
      search_terms = {:search_terms => 'iran,shiraz',:author_search_terms => 'authorid', :date => '2010-10-04'}
      data = @package::Photos.new @photos,search_terms
      assert_equal '/flickr/search?page=1&search_terms=iran%2Cshiraz',data.search_url,'search url is properly set'
    end

    should 'use page when given' do
      assert_equal '/flickr/search?page=2&search_terms=iran%2Cshiraz',@data.search_url(:page => 2),'search url is properly set'
    end

    should 'cap page number maxiumum' do
      assert_equal '/flickr/search?page=800&search_terms=iran%2Cshiraz',@data.search_url(:page => 20000),'search url is properly capped'
    end

    should 'utilize base_url' do
      search_terms = {:search_terms => 'iran,shiraz',:base_url => 'http://www.happy.com'}
      data = @package::Photos.new @photos,search_terms
      assert_equal 'http://www.happy.com?page=1&search_terms=iran%2Cshiraz',data.search_url,'search url uses base_url'
    end

    should 'use author_search_terms with empty search terms' do
      data = @package::Photos.new @photos,{:author_search_terms=> 'authorid',:date => '2001-11-10'}
      assert_equal '/flickr/search?author_search_terms=authorid&page=1',data.search_url,'properly returned author search terms'
    end
    should 'use pages with :author_search_terms' do
      data = @package::Photos.new @photos,{:author_search_terms=> 'authorid',:date => '2001-11-10'}
      assert_equal '/flickr/search?author_search_terms=authorid&page=2',data.search_url(:page=> '2'),'properly used page with author search terms'
    end

    should 'use date with empty search_terms' do
      data = @package::Photos.new @photos,{:date => '2001-11-10'}
      assert_equal '/flickr/search?date=2001-11-10&page=1',data.search_url,'properly returned date'
    end
    should 'use pages with date' do
      data = @package::Photos.new @photos,{:date => '2001-11-10'}
      assert_equal '/flickr/search?date=&page=2',data.search_url(:page => '2'),'properly returned date with page'
    end
    should 'cap pages with date' do
      data = @package::Photos.new @photos,{:date => '2001-11-10'}
      page = data.length() + 200
      assert_equal "/flickr/search?date=&page=#{data.length}",data.search_url(:page => "#{page}" ),'properly returned date with page'
    end
    should 'prefer :search_terms over :date' do
      data = @package::Photos.new @photos,{}
      assert_equal "/flickr/search?date=2010-01-01&page=4",data.search_url(:date => '2010-01-01',:page => '4', :search_terms => 'hello' ),'properly returned date with page'
    end
    should 'take default :page,:search_terms if none specified' do
      data = @package::Photos.new @photos,{ :search_terms =>'iran,shiraz,tehran'}
      assert_equal '/flickr/search?page=1&search_terms=iran%2Cshiraz%2Ctehran',data.search_url,'properly used default values :)'
    end
    should 'take default :page,:date if none specifed' do
      data = @package::Photos.new @photos,{ :date =>'2010-01-02'}
      assert_equal '/flickr/search?date=2010-01-02&page=1',data.search_url,'properly used default values :)'
    end
  end

  context ':prev_date_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      @data = @package::Photos.new @photos,:date => '2010-01-01'
    end
    should 'give correct url when no date specified' do
      assert_equal '/flickr/search?date=2009-12-31&page=1',@data.prev_date_url,'correct url without specifying date'
    end
    should 'give correct url when date specified' do
      assert_equal '/flickr/search?date=2010-02-13&page=1',@data.prev_date_url('2010-02-14'),'correct url when date specified'
    end
    should 'give correct url when date is Time' do
      assert_equal '/flickr/search?date=2010-02-13&page=1',@data.prev_date_url(Chronic.parse('february 14 2010')), 'correctly accepts date object'
    end
    should 'give correct url when date is Hash' do
      assert_equal '/flickr/search?date=2010-02-13&page=1',@data.prev_date_url(:date => '2010-02-14'), 'correctly accepts hash'
    end
  end

  context ':next_date_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
    end
    should 'give correct url when no date specified' do
      data = @package::Photos.new @photos,:date => '2010-01-01'
      assert_equal '/flickr/search?date=2010-01-02&page=1',data.next_date_url,'gives correct next page when date unspecified'
    end
    should 'give correct url when date specified' do
      data = @package::Photos.new @photos,:date => '2010-01-01'
      assert_equal '/flickr/search?date=2010-02-15&page=1',data.next_date_url('2010-02-14'),'gives correct url when date specified'
    end
    should 'give nil when next date does not exist' do
      yesterday = Chronic.parse('yesterday')
      data = @package::Photos.new @photos, :date => yesterday
      assert_equal nil,data.next_date_url(yesterday)
    end
    should 'give url when date is a Hash' do
      data = @package::Photos.new @photos,:date => '2010-01-01'
      assert_equal '/flickr/search?date=2010-01-04&page=1',data.next_date_url(:date => '2010-01-03'), 'hash properly taken'
    end
    should 'give url when date is Time object' do
      data = @package::Photos.new @photos,:date => '2010-01-01'
      assert_equal '/flickr/search?date=2009-01-03&page=1',data.next_date_url(Chronic.parse('January 2 2009'))
    end
  end


  context ':base_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      @options = {:search_terms => 'iran,shiraz'}
    end
    should 'give correct url when none specified' do
      assert_equal '/flickr/search',@package::Photos.new(@photos,@options).base_url,'correct default specified'
    end
    should 'give correct url when specified' do
      assert_equal '/flickr/hullabaloo',@package::Photos.new(@photos,@options.clone.merge({:base_url => '/flickr/hullabaloo'})).base_url,'correct default specified'
    end
  end

  context ':empty?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = @package::Photos.new(fixtures.photos, {:search_terms => 'iran,shiraz'})
    end
    should 'give non-empty' do
      assert !@photos.empty?, 'correctly identified @photos as non-empty'
    end
  end

  context ':prev_date' do
    setup do
      @package = FlickrMocks
      @fixtures = FlickrFixtures
      @photos = @package::Photos.new(@fixtures.photos, {:search_terms => 'iran,shiraz', :date => '2010-01-01'})
    end
    should 'give correct previous date' do
      assert_equal '2009-12-31',@photos.prev_date, 'correctly gives previous day'
    end
    should 'accept date as argument' do
      assert_equal '2009-11-20',@photos.prev_date('2009-11-21'), 'correctly gives previous day'
    end
  end

  context ':next_date' do
    setup do
      @package = FlickrMocks
      @fixtures = FlickrFixtures
      @photos = @package::Photos.new(@fixtures.photos, {:search_terms => 'iran,shiraz', :date => '2010-01-01'})
    end
    should 'give correct next page if no options' do
      assert_equal '2010-01-02',@photos.next_date, 'correctly gives previous day'
    end
    should 'give correct next page if date specified' do
      assert_equal '2010-01-01',@photos.next_date('2009-12-31'),'correctly gives next day'
    end
    should 'return nil if passed in date is yesterday' do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal date,@photos.next_date(date),'yesterday does not have a next date'
    end
  end

  context ':usable_entries' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @interesting = @package::Photos.new fixtures.interesting_photos,{:date => '2010-08-17'}
    end
    should 'return correct number of entries that can be used for commercial purposes' do
      assert_equal 1,@interesting.usable_entries,'correct number of :usable_entries returned'
    end
  end

  context ':usable_entries?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @interesting = @package::Photos.new fixtures.interesting_photos,{:date => '2009-10-02'}
    end
    should 'detect that there are usable entries' do
      assert @interesting.usable_entries?,'correctly determined that usable entries were visible'
    end
    should 'detect that there are no usable entries' do
      @interesting.stubs(:usable_entries).returns(0)
      assert !@interesting.usable_entries?,'correctly determined that there are no usable entries'
    end
  end

  context ':single_page?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @interesting = @package::Photos.new fixtures.interesting_photos,{:date => '2009-10-02'}
    end
    should 'identifies properly where number of pages is zero' do
       @interesting.stubs(:total_pages).returns(0)
       assert !@interesting.single_page?,'correctly identifies that there isn\'t a single pages'
    end
    should 'identify that there is a single page' do
      @interesting.stubs(:total_pages).returns(1)
      assert @interesting.single_page?,'correctly identifies that there is a single page'
    end
    should 'identify that were not a single page' do
      @interesting.stubs(:total_pages).returns(10)
      assert !@interesting.single_page?, 'correctly identifies that was not a single page'
    end
  end
  context ':multi_page?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @interesting = @package::Photos.new fixtures.interesting_photos,{:date => '2009-10-02'}
    end
    should 'identifies properly where number of pages is zero' do
       @interesting.stubs(:total_pages).returns(0)
       assert !@interesting.multi_page?,'correctly identifies that there aren\'t multiple pages'
    end
    should 'identify that there is multiple pages' do
      @interesting.stubs(:total_pages).returns(1)
      assert !@interesting.multi_page?,'correctly identifies that there aren\'t multiple pages'
    end
    should 'identify that were not multiple pages' do
      @interesting.stubs(:total_pages).returns(10)
      assert @interesting.multi_page?, 'correctly identifies that were multiple pages'
    end
  end

end



