require File.expand_path(File.dirname(__FILE__) + '/../../helper')
class TestFlickrMocks_ApiOptions < Test::Unit::TestCase

context 'self.search_options ' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @extras = {
        :license => '4,5,6,7',
        :media => 'photos',
        :extras =>  'license',
        :tag_mode => 'any'
      }
      @expected = {
        :per_page => '400',
        :user_id => nil,
        :tags => 'iran,shiraz',
        :page => '2'}.merge(@extras.clone)
      @options = {
        :search_terms => 'iran,shiraz',
        :page => '2'
      }.merge(@extras.clone)
    end

    should 'give correct values when all but :owner_id is specified' do
      assert_equal @expected, @c.search_options(@options.clone.merge(:per_page => '400'))
    end
    
    should 'return proper options when fully specified' do
      assert_equal @expected.clone.merge(:user_id => 'authorid',:tags => nil),@c.search_options(:per_page => '400',
                                                            :owner_id => 'authorid',
                                                            :page => '2'),'properly parsed options for author'
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
      assert_equal @expected.clone.merge({:extras => 'license'}),@c.interesting_options(@expected), 'gave correct parameters with default hash'
    end
    should 'give proper date with no page' do
      assert_equal @expected.clone.merge({:page => '1',:extras => 'license'}),@c.interesting_options({:date=> '2010-02-14',:per_page=>'2'})
    end
    should 'give proper date when none specified' do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      assert_equal date,@c.interesting_options({})[:date],'correct date returned'
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
  
  context 'self.search_params' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @expected = {
        :search_terms => 'iran,shiraz',
        :owner_id => 'authorid',
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

  context 'self.interesting_params' do
    setup do
      @package = FlickrMocks
      @c = @package::Api
      @expected = {
        :date => 'iran,shiraz',
        :base_url => 'http://www.happyboy.com/'
      }
    end
    should 'behave properly with fully specified options' do
      assert_equal @expected,@c.interesting_params(@expected),'default parameters behave correctly'
    end
    should 'filter non-required options' do
      assert_equal @expected,@c.interesting_params(@expected.clone.merge({:search_terms => 'iran,shiraz',:owner_id => 'authorid'}))
    end
    should 'properly extract :base_url' do
      assert_equal @expected.clone.merge({:base_url => 'http://www.illusion.com/'}),@c.interesting_params(@expected.clone.merge({:base_url => 'http://www.illusion.com/'}))
    end
  end




end