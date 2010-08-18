require File.expand_path(File.dirname(__FILE__) + '/../../helper')
require 'ruby-debug'

class TestFlickrMocks_Photo < Test::Unit::TestCase

  context 'Flickr::Photo' do
    setup do
      @package = FlickrMocks
      @search_terms = {:search_terms => 'iran'}
      fixtures = FlickrFixtures 
      @photos = @package::Photos.new fixtures.photos,@search_terms
      @photo = @package::Photo.new fixtures.photo
    end

    should 'get correct basic accesor methods' do
      assert @photo.is_a? @package::Photo
      assert_equal '4902722511',@photo.id,':id given correctly'
      assert_equal '73934501@N00',@photo.owner,':owner not correct'
      assert_equal '4123',@photo.server,':server not correct'
      assert_equal 5,@photo.farm,':farm not correct'
      assert_equal "Tehran veduta notturna",@photo.title,':title not correct'
      assert_equal 1,@photo.ispublic,':ispublic not correct'
      assert_equal 0,@photo.isfamily, ':isfamily not correct'
      assert_equal 'photo',@photo.flickr_type,':flickr_type not correct'
    end

    should 'get correct urls' do
      url = 'http://farm5.static.flickr.com/4123/4902722511_2c4465a03f'
      assert_equal "#{url}_s.jpg",@photo.square,':square gives incorrect url'
      assert_equal "#{url}_t.jpg",@photo.thumbnail,':thumbnail gives incorrect url'
      assert_equal "#{url}_m.jpg",@photo.small,':small gives incorrect url'
      assert_equal "#{url}.jpg",@photo.medium,':medium gives incorrect url'
      assert_equal "#{url}_b.jpg",@photo.large,':large gives incorrect url'
      assert_equal "#{url}_z.jpg",@photo.send(:'medium 640'),":'medium 640' gives incorrect url"
      assert_equal "#{url}_z.jpg",@photo.medium_640,"medium_640 gives incorrect url"
    end

     should 'give correct author_url methods' do
      assert_equal "http://www.flickr.com/photos/73934501@N00/4902722511", @photo.author_url, 'author url properly given'
    end

  end

end