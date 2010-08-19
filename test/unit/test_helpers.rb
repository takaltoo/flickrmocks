require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_Helpers < Test::Unit::TestCase
  context ':extension' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end

    should 'behave properly for :extension' do
      assert_equal '.marshal',@h.extension,'proper extension not given'
    end
  end

  context ':fname_fixture' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end
    should 'behave properly for :fname_fixture' do
      assert_equal 'hello.marshal',@h.fname_fixture(:hello),'simple symbol works properly'
    end
  end

  context ':equivalent?' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end

    should 'detect that photo_details equivalent to itself' do
      assert @h.equivalent?(@f.photo_details,@f.photo_details), 'photo_details equivalent to itself'
    end
    should 'detect that photo_sizes equivalent to itself' do
      assert @h.equivalent?(@f.photo_sizes,@f.photo_sizes), 'photo_sizes equivalent to itself'
    end
    should 'detect :photos equivalent to itself' do
      assert @h.equivalent?(@f.photos,@f.photos), 'photos equivalent to itself'
    end
    should 'detect differences between photo_details and photo' do
      assert !@h.equivalent?(@f.photo_details,@f.photos[0]), 'photo_details not equivalent to photo'
    end
    should 'detect differences between photo_sizes and photo_details' do
      assert !@h.equivalent?(@f.photo_sizes,@f.photo_details), 'photo_details not equivalent to photo_sizes'
    end
  end

  context ':dump and :load methods' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
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
