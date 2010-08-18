require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_Photos < Test::Unit::TestCase
  context 'Photos' do
    setup do
      @package = FlickrMocks
      @search_terms = {:search_terms => 'iran'}
      @date = {:date => '2009-10-02'}

      fixtures = FlickrFixtures

      @photos = @package::Photos.new fixtures.photos,@search_terms
      @interesting = @package::Photos.new fixtures.photos, @date

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

      # can read attributes
      assert_equal 4000, @package::Photos.defaults[:max_entries],'can read :max_entries'
      assert_equal 50,@package::Photos.defaults[:per_page],'can read :per_page'
      assert_equal '/flickr/search',@package::Photos.defaults[:base_url],'can read :base_url'

      # can write attributes
      check_attribute_write :max_entries,:per_page,:base_url
    end

    should 'be able to read attributes' do
      assert_equal 1,@photos.current_page,':current_page properly set'
      assert_equal 5,@photos.per_page,':per_page properly set'
      assert_equal 276362,@photos.total_entries,':total_entries properly set'
      assert_equal 'iran',@photos.search_terms,':search_terms properly set'
      assert_equal 4000, @photos.max_entries,':max_entries properly set'
      assert_equal @photos.photos,@photos.collection,':collection is equal to :photos'
      assert_equal '2009-10-02',@interesting.date,':date is accessible'
    end

    should 'be able to iterate through each page' do
      pages = []
      @photos.each_page do |page| pages.push page end
      range = 1..@photos.total_pages
      reference = range.map {|num| num}
      assert_equal reference,pages,':each_page can be iterated'
    end

    should 'be able to iterate with each_photo' do
      count = 0
      @photos.each_photo do |photo|
        assert photo.is_a?(@package::Photo),":each_photo properly iterates"
        count+=1
      end
      assert_equal @photos.per_page,count
    end


    should 'give correct pages with url' do
      count=1
      @photos.pages_with_url do |datum|
        assert datum.current_page,':current_page properly set'
        assert_equal count,datum.page,':page properly set'
        assert_equal @photos.search_url(count),datum.url,':url properly set'
        count+=1
      end
    end

    should 'give correct index with :[]' do
      assert_equal @photos.collection[0], @photos[0],':[] works properly'
      assert_equal @photos.collection[-1], @photos[-1],':[] works properly'
      assert_equal @photos.collection[3], @photos[3],':[] works properly'
      assert_equal @photos[0],@photos.first,':[] works properly'
      assert_equal @photos[-1],@photos.last,':[] works properly'
    end

    should 'give correct :total_pages and :length' do
      assert_equal 800,@photos.total_pages,':total_pages properly set'
      assert_equal @photos.length,@photos.total_pages,':total_pages properly set'
    end

    
    should 'give correct search_url' do
      default_url = @package::Photos.defaults[:base_url]
      assert_equal '/flickr/search?page=1&search_terms=iran',@photos.search_url,':search_url properly given'
      @package::Photos.defaults[:base_url]='/googoo'
      assert_equal '/googoo?page=1&search_terms=iran',@photos.search_url,':search_url properly given'
      @package::Photos.defaults[:base_url]=default_url
    end

    should 'give correct next page' do
      assert_equal 2,@photos.next_page,':next_page given'
      assert_equal 1,@photos.next_page(0),':next_page given'
      assert_equal 1,@photos.next_page(-1),':next_page given'
      assert_equal 3,@photos.next_page(2),':next_page given'
      assert_equal 800,@photos.next_page(799),':next_page given'
      assert_equal 800,@photos.next_page(800),':next_page given'
      assert_equal 800,@photos.next_page(8001),':next_page given'
    end

    should 'give correct prev_page' do
      assert_equal 1,@photos.prev_page,':prev_page given'
      assert_equal 1,@photos.prev_page(0),':prev_page given'
      assert_equal 1,@photos.prev_page(-1),':prev_page given'
      assert_equal 1,@photos.prev_page(2),':prev_page given'
      assert_equal 798,@photos.prev_page(799),':prev_page given'
      assert_equal 799,@photos.prev_page(800),':prev_page given'
      assert_equal 800,@photos.prev_page(801),':prev_page given'
    end

    should 'give correct capped? value' do
      assert @photos.capped?,':capped? is correct'
    end
  end
  
  context '@package::Photos should give proper search_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      options =  {:search_terms => 'iran,shiraz',:date => '2010-10-04'}
      @data = @package::Photos.new @photos,options
    end

    should 'give :search_terms when present' do
      search_terms = {:search_terms => 'iran,shiraz',:date => '2010-10-04'}
      data = @package::Photos.new @photos,search_terms
      assert_equal '/flickr/search?page=1&search_terms=iran%2Cshiraz',data.search_url,'search url is properly set'
    end

    should 'use page when given' do
      assert_equal '/flickr/search?page=2&search_terms=iran%2Cshiraz',@data.search_url(2),'search url is properly set'
    end

    should 'cap page number maxiumum' do
       assert_equal '/flickr/search?page=800&search_terms=iran%2Cshiraz',@data.search_url(20000),'search url is properly capped'
    end

    should 'utilize base_url' do
      search_terms = {:search_terms => 'iran,shiraz',:base_url => 'http://www.happy.com'}
      data = @package::Photos.new @photos,search_terms
      assert_equal 'http://www.happy.com?page=1&search_terms=iran%2Cshiraz',data.search_url,'search url uses base_url'
    end




  end

  context ':date_hash' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      @options =  {:search_terms => 'iran,shiraz',:date=>'2010-07-20'}
      @data = @package::Photos.new @photos,@options
    end
    should 'support empty? on non-specified date' do
      data =@package::Photos.new @photos,{:search_terms => 'iran,shiraz'}
      assert !data.date_hash.empty?,'Hash was not empty'
    end
    should 'properly return :date_hash' do
      expected = {:date => '2010-07-20'}
      assert_equal expected,@data.date_hash,'date hash is properly returned'
    end
    should 'be able to respond to empty?' do
      data = @package::Photos.new @photos,{}
      assert !data.date_hash.empty?, 'detected that :date is non-empty'
    end
    should 'give yesterday if date is current or in future' do
      future = Chronic.parse('ten days from now').strftime('%Y-%m-%d')
      yesterday = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      data = @package::Photos.new @photos,{:date => future}
      assert_equal yesterday,data.date,'date properly clipped at yesterday'
    end
  end

  context ':search_terms_hash' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photos = fixtures.photos
      @options =  {:search_terms => 'iran,shiraz'}
      @data = @package::Photos.new @photos,@options
    end
    should 'properly return search_terms_hash' do
      assert_equal @options, @data.search_terms_hash
    end
    should 'be able to detect empty search_terms_hash' do
      data = @package::Photos.new @photos,{}
      assert data.search_terms_hash.empty?, 'detected empty search terms'
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


end



