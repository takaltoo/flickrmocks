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

      @photos = @h.marshal_load @photos_m
      @details = @h.marshal_load @details_m
      @sizes = @h.marshal_load @sizes_m
      
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

    should 'properly marshal and unmarshal object' do
      assert_equal @photos_m, @h.marshal_dump(@photos)
      assert_equal @details_m, @h.marshal_dump(@details)
      assert_equal @sizes_m, @h.marshal_dump(@sizes)

      assert @h.compare(@photos, @h.marshal_load(@h.marshal_dump(@photos)))
      assert @h.compare(@details, @h.marshal_load(@h.marshal_dump(@details)))
      assert @h.compare(@sizes, @h.marshal_load(@h.marshal_dump(@sizes)))

      assert @h.compare(@photos_m,@h.marshal_dump(@h.marshal_load(@photos_m)))
      assert @h.compare(@details_m,@h.marshal_dump(@h.marshal_load(@details_m)))
      assert @h.compare(@sizes_m,@h.marshal_dump(@h.marshal_load(@sizes_m)))
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
      begin
        expected = [1,2,3,7]
        fname ='/tmp/' + Time.now.to_s + Random.rand.to_s
        @h.marshal(expected,fname)
        value = @h.unmarshal(fname)
        assert_equal expected,value
      ensure
        File.delete(fname)
      end
    end

  end
end
