require File.expand_path(File.dirname(__FILE__) + '/../../helper')

class TestFlickrMocks_PhotoDimensions < Test::Unit::TestCase
  context 'string initialization like: "square:1x1,thumbnail:2x2,small:3x3,medium:4x4,medium_640:4x4,large:5x5,original:6x6"' do  
    setup do
      @dimensions = FlickrMocks::PhotoDimensions.new('square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17')
    end

    should 'return available sizes' do
      assert_equal [:square, :thumbnail, :small, :medium, :medium_640, :large, :original],@dimensions.available_sizes, 'correct sizes returned'
    end

    should 'respond to square' do
      expected = OpenStruct.new :width => 1, :height =>11
      assert expected == @dimensions.square, 'square dimension properly returned'
    end

    should 'respond to thumbnail' do
      expected = OpenStruct.new :width => 2, :height =>12
      assert expected == @dimensions.thumbnail, 'thumbnail dimension properly returned'
    end

    should 'respond to small' do
      expected = OpenStruct.new :width => 3, :height =>13
      assert expected == @dimensions.small, 'small dimension properly returned'
    end

    should 'respond to medium' do
      expected = OpenStruct.new :width => 4, :height =>14
      assert expected == @dimensions.medium, 'medium dimension properly returned'
    end

    should 'respond to medium_640' do
      expected = OpenStruct.new :width => 5, :height =>15
      assert expected == @dimensions.medium_640, 'medium_640 dimension properly returned'
    end

    should 'respond to large' do
      expected = OpenStruct.new :width => 6, :height =>16
      assert expected == @dimensions.large,'large dimension properly returned'
    end

    should 'respond to original' do
      expected = OpenStruct.new :width => 7, :height =>17
      assert expected == @dimensions.original,'original dimensions properly returned'
    end

    should ':each' do
      sizes = []
      @dimensions.each do |size|
        sizes.push(size)
      end
      assert_equal 'square,thumbnail,small,medium,medium_640,large,original',sizes.join(','),'each iterates through the sizes'
    end

    should ':each_with_dimensions' do
      result = []
      @dimensions.each_with_dimensions do |size,dimensions|
        result.push([size,[dimensions.width,dimensions.height].join('x')].join(':'))
      end
      assert_equal "square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17",result.join(','),'properly returned dimensions'
    end

    should ':each_dimensions_string' do
      result =[]
      @dimensions.each_dimensions_string do |string|
        result.push string
      end
      assert_equal "square (1x11),thumbnail (2x12),small (3x13),medium (4x14),medium_640 (5x15),large (6x16),original (7x17)",result.join(','),'correct strings returned for dimensions'
    end

    should 'return string representation of data' do
      assert_equal 'square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17',@dimensions.to_s,'correct dimension returned'
    end

  end

  context 'available sizes' do
    should 'only give sizes that were specified' do
      dimensions = FlickrMocks::PhotoDimensions.new 'square:1x11,thumbnail:2x12'
      assert_equal [:square,:thumbnail],dimensions.available_sizes,"only :square and :thumbnail returns"
    end
    should 'return correct order when all sizes are out of order' do
      dimensions = FlickrMocks::PhotoDimensions.new 'thumbnail:2x12,small:3x13,square:1x11,large:6x16,medium_640:5x15,original:7x17,medium:4x14'
      assert_equal 'square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17',
        dimensions.to_s,'correct dimension order returned'
    end
    should 'return correct order when some options are specified' do
      dimensions = FlickrMocks::PhotoDimensions.new 'small:3x13,square:1x11,large:6x16,medium_640:5x15,medium:4x14'
      assert_equal 'square:1x11,small:3x13,medium:4x14,medium_640:5x15,large:6x16',dimensions.to_s,'order is correct'
    end

    should 'refuse to accept strings with improper form' do
      assert_raise(ArgumentError) { FlickrMocks::PhotoDimensions.new 'square:1x11,'}
    end
  end
  
  context 'initialization should not accept bad strings' do
    should 'non-recognized sizes throw exception' do
      assert_raise(ArgumentError) { FlickrMocks::PhotoDimensions.new 'square:1x11,garbage:3x33,thumbnail:2x12' }
    end
    should 'not accept strings with extra commas' do
      assert_raise(ArgumentError) { FlickrMocks::PhotoDimensions.new 'square:1x11,garbage:3x33,thumbnail:2x12,' }
    end
  end

  context 'self.size_regexp behaves properly' do
    setup do
      @p = FlickrMocks::PhotoDimensions
    end
    should 'accept proper strings' do
      assert @p.size_regexp =~ 'square:1x11,thumbnail:2x12', "proper sizes are recognized"
    end
    should 'not accept extraneous commas' do
      assert !(@p.size_regexp =~ 'square:1x11,thumbnail:2x12,'),'extraneous commas not accepted'
    end
    should 'not accept missing colons' do
      assert !(@p.size_regexp =~ 'square1x11,thumbnail:2x12,'),'missing colons not acceptable'
    end
  end
  
end
