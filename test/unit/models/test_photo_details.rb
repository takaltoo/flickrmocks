require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_PhotoDetails < Test::Unit::TestCase
  context 'FlickrMocks::Photo' do
    setup do
      @package = FlickrMocks
      fixtures = FlickrFixtures
      @photo = @package::Photo.new fixtures.photo_details
      @sizes = @package::PhotoSizes.new fixtures.photo_sizes
      @details = @package::PhotoDetails.new @photo,@sizes
    end


    should 'correctly delegate to @photo' do
      [:id, :secret, :server, :farm, :dateuploaded, :isfavorite, :license, :rotation, :owner, :title,
        :description, :visibility, :dates, :views, :editability, :usage, :comments,
        :notes, :tags, :urls, :media, :flickr_type,:small,:square,:thumbnail,:medium,:'medium 640',:large].each do |method|
        assert_equal @photo.send(method.to_sym),@details.send(method.to_sym),"gives correct #{method.to_sym}"
      end
    end

    should 'correct class for :sizes' do
      assert_equal @package::PhotoSizes,@details.sizes.class,'sizes properly stored'
    end


    should 'correctly give author name' do
      assert_equal "Steven",@details.author, 'correct author name'
    end

    should 'respond to :original' do
      assert @details.respond_to?(:original),'original method is present'
    end

  end

end