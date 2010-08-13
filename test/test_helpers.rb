require 'helper'
require 'ostruct'
require 'ruby-debug'


class TestFlickrmocks < Test::Unit::TestCase
  context 'class methods for Helper' do
    setup do
      @h = FlickrMocks::Helpers
      @o = OpenStruct

      @photos  = load_flickr_response :photos
      @details =  load_flickr_response :photo_details
      @sizes = load_flickr_response :sizes
      
    end
    should 'give correct extension. :extension' do
      assert_equal '.marshal',@h.extension,'proper extension not given'
    end

    should 'give correct filename for photo' do
      debugger
      assert_equal 'photo_id_22.marshal',@h.fname_photo(@o.new({:photo_id => '22'}))
      assert_equal 'photo_id_222.marshal',@h.fname_photo(@o.new({:id => '222'}))
      assert_equal 'photo_id_22.marshal',@h.fname_photo(@o.new({:photo_id=> '22',:id => '222'}))
    end

    should 'give correct filename for photos' do
      assert_equal 'photos_iran_tehran.marshal',@h.fname_photos({:tags => 'iran,tehran'})
      assert_equal 'photos_iran_tehran.marshal',@h.fname_photos({:tags => 'teHran,Iran'})
      assert_equal 'photos_iran_tehran_tagmode_all.marshal',@h.fname_photos({:tags => 'teHran,Iran',:tag_mode =>'all'})
      assert_equal 'photos_iran_perpage_333.marshal',@h.fname_photos({:tags => 'iran',:per_page=>'333'})
      assert_equal 'photos_iran_page_2000.marshal',@h.fname_photos({:tags => 'iran',:page=>'2000'})
      assert_equal 'photos_iran_perpage_333_page_2000_tagmode_any.marshal',@h.fname_photos({:tags => 'iran',:page=>'2000',:per_page=>'333',:tag_mode =>'any'})
    end

    should 'give correct filename for sizes' do
      assert_equal 'sizes_photo_id_22.marshal',@h.fname_sizes(@o.new({:photo_id => '22'}))
      assert_equal 'sizes_photo_id_222.marshal',@h.fname_sizes(@o.new({:id => '222'}))
      assert_equal 'sizes_photo_id_22.marshal',@h.fname_sizes(@o.new({:photo_id=> '22',:id => '222'}))
    end


    should 'properly compare objects' do
      assert @h.compare(@details,@details), 'FlickRaw::Response class should be equal to itself'
      assert @h.compare(@sizes,@sizes), 'FlickRaw::ResponseList class should be equal to itself'
      assert @h.compare(@photos,@photos), 'FlickRaw::ResponseList class should be equal to itself'

      assert !@h.compare(@details,@sizes), 'should detect differences in FLickRaw::Response'
      assert !@h.compare(@sizes,@details), 'should detect differences in FlickRaw::ResponseList'
    end

    should 'be able to marshal and unmarshal files' do
        assert @h.compare(Marshal.load(Marshal.dump(@photos)),@photos), 'marshal/unmarshal same object should not change object'
        assert @h.compare(Marshal.load(Marshal.dump(@sizes)),@sizes), 'marshal/unmarshal same object should not change object'
        assert @h.compare(Marshal.load(Marshal.dump(@details)),@details), 'marshal/unmarshal same object should not change object'        
        assert @h.compare(Marshal.load(Marshal.dump(Marshal.load(Marshal.dump(@photos)))),@photos), 'multiple marshal/unmarshal should not change object'
    end

  end
end
