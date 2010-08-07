require 'helper'
require 'ostruct'
require 'ruby-debug'


class TestFlickrmocks < Test::Unit::TestCase
  context 'class methods for Helper' do
    setup do
      @h = FlickrMocks::Helpers
      @o = OpenStruct

      @photos_m  = load_flickr_response :photos
      @details_m =  load_flickr_response :photo_details
      @sizes_m = load_flickr_response :sizes

      @photos = FlickRaw::Response.build(@photos_m,'photos')
      @details = FlickRaw::Response.build(@details_m,'photo')
      @sizes = FlickRaw::Response.build(@sizes_m,'sizes')
      
    end
    should 'give correct extension. :extension' do
      assert_equal '.marshal',@h.extension,'proper extension not given'
    end

    should 'give correct filename for photo' do
      assert_equal 'photo_id_22.marshal',@h.fname_photo(@o.new({:photo_id => '22'}))
      assert_equal 'photo_id_222.marshal',@h.fname_photo(@o.new({:id => '222'}))
      assert_equal 'photo_id_22.marshal',@h.fname_photo(@o.new({:photo_id=> '22',:id => '222'}))
    end

    should 'give correct filename for photos' do
      assert_equal 'photos_iran_tehran.marshal',@h.fname_photos({:tags => 'iran,tehran'})
      assert_equal 'photos_iran_tehran.marshal',@h.fname_photos({:tags => 'teHran,Iran'})
      assert_equal 'photos_iran_tehran_tagmode_all.marshal',@h.fname_photos({:tags => 'teHran,Iran',:tag_mode =>'all'})
      assert_equal 'photos_iran_perpage_333.marshal',@h.fname_photos({:tags => 'iran',:perpage=>'333'})
      assert_equal 'photos_iran_page_2000.marshal',@h.fname_photos({:tags => 'iran',:page=>'2000'})
      assert_equal 'photos_iran_perpage_333_page_2000_tagmode_any.marshal',@h.fname_photos({:tags => 'iran',:page=>'2000',:perpage=>'333',:tag_mode =>'any'})
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

      assert @h.compare(@details_m,@details_m), 'Marshaled FlickRaw::Response class should be equal to itself'
      assert @h.compare(@sizes_m,@sizes_m), 'Marshaled FlickRaw::ResponseList class should be equal to itself'
      assert @h.compare(@photos_m,@photos_m), 'Marshaled FlickRaw::ResponseList class should be equal to itself'

      assert !@h.compare(@photos_m,@photos_m.clone["photo"][-1]["farm"] = 'mistake'), 'should be able to pick up slight differences'
      assert !@h.compare(@details_m,@details_m.clone["comments"] = [1,2,3,4]),'should be able to detect slight difference'
      assert !@h.compare(@sizes_m,@sizes_m["size"][-1]["height"]+='2' ),'should be able to detect slight difference'
    end

    should 'be able to marshal and unmarshal files' do
        assert @h.compare(Marshal.load(Marshal.dump(@photos)),@photos), 'marshal/unmarshal same object should not change object'
        assert @h.compare(Marshal.load(Marshal.dump(@sizes)),@sizes), 'marshal/unmarshal same object should not change object'
        assert @h.compare(Marshal.load(Marshal.dump(@details)),@details), 'marshal/unmarshal same object should not change object'

        assert @h.compare(Marshal.load(Marshal.dump(Marshal.load(Marshal.dump(@photos)))),@photos), 'multiple marshal/unmarshal should not change object'

    end

  end
end
