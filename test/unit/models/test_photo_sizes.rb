require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_PhotoSizes < Test::Unit::TestCase
  context 'each' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end

    should 'iterate through sizes' do
      count=0
      @sizes.each do |size|
        assert_equal @sizes.sizes[count],size,'correct size set'
        count+=1
      end
    end
  end

  context 'empty?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'identifies that size is non-empty' do
      assert !@sizes.empty?
    end
    should 'identify an empty size' do
      @sizes.stubs(:empty?).returns(true)
      assert @sizes.empty?,'empty sizes'
    end
  end

  context 'index' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'return :[1]' do
      assert_equal @sizes.sizes[1],@sizes[1],':[1] correctly returned'
    end
    should 'return :[-1]' do
      assert_equal @sizes.sizes[-1],@sizes[-1],':[-1] correctly returned'
    end
    should 'return :first' do
      assert_equal @sizes[0],@sizes.first,'first element returned'
    end
    should 'return :last' do
      assert_equal @sizes[-1],@sizes.last,'last element returned'
    end
  end

  context ':member_class' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    # don't know why this method is required by Hobo
    should 'respond to member_class' do
      assert @sizes.respond_to? :member_class,'empty method required by hobo properly set'
    end
  end

  context 'size methods' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'respond to :small method' do
      index = @sizes.size_index(:small)
      assert_equal @sizes[index], @sizes.small,"Sizes respond to :small"
    end
    should 'respond to :large method' do
      index = @sizes.size_index(:large)
      assert_equal @sizes[index], @sizes.large,"Sizes respond to :large"
    end
    should 'respond to :medium method' do
      index = @sizes.size_index(:medium)
      assert_equal @sizes[index], @sizes.medium,"Sizes respond to :large"
    end
    should 'respond to :medium_640 method' do
      index = @sizes.size_index(:'medium 640')
      assert_equal @sizes[index], @sizes.medium_640,"Sizes respond to :medium_640"
    end

    should 'respond to :"medium 640" method' do
      index = @sizes.size_index(:'medium 640')
      assert_equal @sizes[index], @sizes.send(:'medium 640'),"Sizes respond to :medium_640"
    end
    

    should 'respond to :thumbnail method' do
      index = @sizes.size_index(:thumbnail)
      assert_equal @sizes[index], @sizes.thumbnail,"Sizes respond to :thumbnail"
    end
    should 'respond to :square method' do
      index = @sizes.size_index(:square)
      assert_equal @sizes[index], @sizes.square,"Sizes respond to :square"
    end


  end

  context ':size_index' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'behave properly for :small' do
      assert_equal 2,@sizes.size_index(:small),'correct :small index'
    end
    should 'behave properly for :medium' do
      assert_equal 3,@sizes.size_index(:medium),'correct :medium index'
    end
    should 'behave properly for :large' do
      assert_equal 5,@sizes.size_index(:large),'correct :large index'
    end
    should 'behave properly for :medium_640' do
      assert_equal 4,@sizes.size_index(:'medium 640'),'correct :medium_640 index'
    end
    should 'behave properly for :square' do
      assert_equal 0,@sizes.size_index(:square),'correct :square index'
    end
    should 'behave properly for :thumbnail' do
      assert_equal 1,@sizes.size_index(:thumbnail),'correct :thumbnail index'
    end
  end

  context ':size_index?' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'true when index exits' do
      assert @sizes.size_index?(:small)
    end
    should 'false when index does not exist' do
      assert !@sizes.size_index?(:notavailable)
    end
  end

  context ':available_sizes' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
    end
    should 'return list of available photo_sizes' do
      assert_equal [:square, :thumbnail, :small, :medium, :"medium 640", :large],@sizes.available_sizes,'properly returned list of available sizes'
    end
  end

end

