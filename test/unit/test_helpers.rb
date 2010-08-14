require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_Helpers < Test::Unit::TestCase
  context 'FlickrMocks::Helpers class methods' do

    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end

    should 'behave properly for :extension' do
      assert_equal '.marshal',@h.extension,'proper extension not given'
    end

    should 'behave properly for :fname_fixture' do
      assert_equal 'hello.marshal',@h.fname_fixture(:hello),'simple symbol works properly'
    end


    should 'behave properly for :equivalent?' do
      assert @h.equivalent?(@f.photo_details,@f.photo_details), 'FlickRaw::Response class should be equal to itself'
      assert @h.equivalent?(@f.photo_sizes,@f.photo_sizes), 'FlickRaw::ResponseList class should be equal to itself'
      assert @h.equivalent?(@f.photos,@f.photos), 'FlickRaw::ResponseList class should be equal to itself'
      assert !@h.equivalent?(@f.photo_details,@f.photos[0]), 'should detect differences in FLickRaw::Response'
      assert !@h.equivalent?(@f.photo_sizes,@f.photo_details), 'should detect differences in FlickRaw::ResponseList'
    end

    should 'behave properly for :dump, :load' do
      begin
        fname = "/tmp/#{Time.now}_#{Random.rand}"
        expected = [Random.rand,Random.rand]
        @h.dump(expected,fname)
        actual = @h.load(fname)
        assert_equal expected,actual,':dump/:load behaves properly'
      ensure
        File.delete fname
      end
      
    end


  end
end
