require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_PhotoSizes < Test::Unit::TestCase
  context 'FlickrMocks::PhotoSizes' do

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

    should 'identify if empty' do
      assert !@sizes.empty?
    end

    should 'be able to index sizes' do
      assert_equal @sizes.sizes[1],@sizes[1],'second index :[] is properly set'
      assert_equal @sizes.sizes[-1],@sizes[-1],'last index :[] is properly set'
      assert_equal @sizes[0],@sizes.first,'first element can be indexed'
      assert_equal @sizes[-1],@sizes.last,'last element can be indexed'
    end

    should 'respond to member_class' do
      assert @sizes.respond_to? :member_class,'empty method required by hobo properly set'
    end

    should 'respond to *size methods' do
      @sizes.available_sizes.each_with_index do |size,index|
        assert_equal @sizes[index], @sizes.send(size),"Sizes respond to: #{size}"
      end
    end

    should 'give correct :index for sizes' do
      assert_equal 2,@sizes.size_index(:small)
      assert_equal 3,@sizes.size_index(:medium)
      assert_equal 5,@sizes.size_index(:large)
      assert_equal 4,@sizes.size_index(:'medium 640')
      assert_equal 0,@sizes.size_index(:square)
      assert_equal 1,@sizes.size_index(:thumbnail)
    end

    should 'be able to deteremine whether size exists' do
      assert @sizes.size_index?(:small)
      assert !@sizes.size_index?(:notavailable)
    end

  end

end
