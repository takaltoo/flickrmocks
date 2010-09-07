require 'ostruct'

module FlickrMocks
  class PhotoDimensions
    # sizes that are recognized by class. The sizes are in order from smallest to largest
    @possible_sizes =  [:square,:thumbnail,:small,:medium,:medium_640,:large,:original]
    @size_regexp = /^[a-z]+(_\d+)?:\d+x\d+(,[a-z]+(_\d+)?:\d+x\d+)*$/

    class << self
      attr_accessor :possible_sizes
      attr_reader :size_regexp
    end
    
    attr_accessor :sizes

    def initialize(data)
      self.sizes = data
    end

    def square
      @sizes.has_key?(:square) ? @sizes[:square] : nil
    end

    def thumbnail
      @sizes.has_key?(:thumbnail) ? @sizes[:thumbnail] : nil
    end

    def small
      @sizes.has_key?(:small) ? @sizes[:small] : nil
    end

    def medium
      @sizes.has_key?(:medium) ? @sizes[:medium] : nil
    end

    def medium_640
      @sizes.has_key?(:medium_640) ? @sizes[:medium_640] : nil
    end

    def large
      @sizes.has_key?(:large) ? @sizes[:large] : nil
    end

    def original
      @sizes.has_key?(:original) ? @sizes[:original] : nil
    end

    def available_sizes
      sizes = []
      PhotoDimensions.possible_sizes.each do |size|
        sizes.push(size) if @sizes.has_key?(size)
      end
      sizes
    end

    def each
      PhotoDimensions.possible_sizes.each do |size|
        yield size.to_s if @sizes.has_key?(size)
      end
    end

    def each_with_dimensions
      PhotoDimensions.possible_sizes.each do |size|
        yield size.to_s,@sizes[size] if @sizes.has_key?(size)
      end
    end

    def each_dimensions_string
      PhotoDimensions.possible_sizes.each do |size|
        yield "#{size.to_s} (#{@sizes[size].width}x#{@sizes[size].height})" if @sizes.has_key?(size)
      end
    end

    def to_s
      result = []
      each_with_dimensions do  |size,dim|
        result.push [size,[dim.width,dim.height].join('x')].join(':')
      end
      result.join(',')
    end

    private

    def sizes=(data)
      raise ArgumentEror, "Invalid #{data} must respond to :to_s" unless data.respond_to?(:to_s)

      @sizes={}
      # expecting strings of type: "square:1x1,thumbnail:2x2,small:3x3,medium:4x4,medium_640:4x4,large:5x5,original:6x6"
      data = data.to_s.downcase

      raise ArgumentError, "Format #{data} is incorrect must be: square:1x1,thumbnail:2x2" unless PhotoDimensions.size_regexp =~ data

      data.gsub(/\s+/,'').split(',').each do |fields|
        size,dim = fields.split(':')
        size= size.to_sym
        width,height=dim.split(/x/)
        raise ArgumentError, "Unrecognized size #{size}. Must be one of #{PhotoDimensions.possible_sizes}" unless FlickrMocks::PhotoDimensions.possible_sizes.include?(size)
        @sizes[size.to_sym] = OpenStruct.new :width => width.to_i,:height => height.to_i
      end
    end


  end
end