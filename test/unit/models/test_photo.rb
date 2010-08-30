require File.expand_path(File.dirname(__FILE__) + '/../../helper')
require 'ruby-debug'

class TestFlickrMocks_Photo < Test::Unit::TestCase

  context 'delegated methods' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures 
      @photo = @package::Photo.new fixtures.photo
    end

    should 'be correct class' do
      assert @photo.is_a?(@package::Photo), 'class is correct'
    end
    should 'give correct :id' do
      assert_equal '4902722511',@photo.id,':id given correctly'
    end
    should 'give correct owner' do
      assert_equal '73934501@N00',@photo.owner,':owner not correct'
    end
    should 'give correct :server' do
      assert_equal '4123',@photo.server,':server not correct'
    end
    should 'give correct farm' do
      assert_equal 5,@photo.farm,':farm not correct'
    end
    should 'give correct :title' do
      assert_equal "Tehran veduta notturna",@photo.title,':title not correct'
    end
    should 'give correct :ispublic' do
      assert_equal 1,@photo.ispublic,':ispublic not correct'
    end
    should 'give correct :isfamily' do
      assert_equal 0,@photo.isfamily, ':isfamily not correct'
    end
    should 'give correct :flickr_type' do
      assert_equal 'photo',@photo.flickr_type,':flickr_type not correct'
    end
  end

  context 'photo url methods' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo
      @url = 'http://farm5.static.flickr.com/4123/4902722511_2c4465a03f'
    end
    should 'get correct :square url' do
      assert_equal "#{@url}_s.jpg",@photo.square,':square gives incorrect url'
    end
    should 'give correct :thumbnail url' do
      assert_equal "#{@url}_t.jpg",@photo.thumbnail,':thumbnail gives incorrect url'
    end
    should 'give correct :small url' do
      assert_equal "#{@url}_m.jpg",@photo.small,':small gives incorrect url'
    end
    should 'give correct :medium url' do
      assert_equal "#{@url}.jpg",@photo.medium,':medium gives incorrect url'
    end
    should 'give correct :large url' do
      assert_equal "#{@url}_b.jpg",@photo.large,':large gives incorrect url'
    end
    should 'give correct :medium url' do
      assert_equal "#{@url}_z.jpg",@photo.send(:'medium 640'),":'medium 640' gives incorrect url"
    end
    should 'give correct :medium_640 url' do
      assert_equal "#{@url}_z.jpg",@photo.medium_640,"medium_640 gives incorrect url"
    end
  end
  
  context ':owner_url' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo
    end
    should 'give correct owner_url methods' do
      assert_equal "http://www.flickr.com/photos/73934501@N00/4902722511", @photo.owner_url, 'owner url properly given'
    end
  end

  context ':owner_id' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo
      @detailed_photo = @package::Photo.new fixtures.photo_details
    end
    should 'return proper owner_id with detailed photo' do
      assert_equal '57529085@N00',@detailed_photo.owner_id,'correct id returned'
    end
  end

  context ':owner' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo
      @detailed_photo = @package::Photo.new fixtures.photo_details
    end
    should 'return proper owner with simple photo' do
      assert_equal '73934501@N00',@photo.owner,'correct id returned'
    end
  end

end