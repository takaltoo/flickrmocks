require File.expand_path(File.dirname(__FILE__) + '/../../helper')
require 'ruby-debug'
class TestFlickrMocks_PhotoDetails < Test::Unit::TestCase
  context 'delegation to @photo' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo_details
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
      @details = @package::PhotoDetails.new @photo,@sizes
    end
    # Note only check a few methods to ensure that delgation occurs
    should 'correctly delegate to :id' do
      assert_equal @photo.id,@details.id,"gives correct :id"
    end
    should 'delegate to :secret' do
      assert_equal @photo.secret,@details.secret,"gives correct :secret"
    end
    should 'delegate to :server' do
      assert_equal @photo.server,@details.server,"gives correct :server"
    end
    should 'delegate to :medium_640' do
      assert_equal @photo.medium_640,@details.medium_640,'gives correct :medium_640'
    end
  end
  
  context 'non-delegated methods' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo_details
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
      @details = @package::PhotoDetails.new @photo,@sizes
    end

    should 'correct class for :sizes' do
      assert_equal @package::PhotoSizes,@details.sizes.class,'sizes properly stored'
    end


    should 'correctly give owner name' do
      assert_equal "Steven",@details.owner_name, 'correct name for owner'
    end

    should 'correctly give owner_username' do
      assert_equal 'lionheart613',@details.owner_username,'correct username for owner'
    end

    should 'respond to :original' do
      assert @details.respond_to?(:original),'original method is present'
    end

  end


  

end

