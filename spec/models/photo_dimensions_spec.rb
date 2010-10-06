require 'spec_helper'

describe APP::PhotoDimensions do


  let(:expected_sizes) { [:square, :thumbnail, :small, :medium,:medium_640, :large, :original].map(&:to_s) }
  let(:expected_dimensions) {[[1,11],[2,12],[3,13],[4,14],[5,15],[6,16],[7,17]]}
  let(:klass) {APP::PhotoDimensions}
  let(:dimensions_string) {'square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17'}
  
  subject { APP::PhotoDimensions.new(dimensions_string) }

  describe "initialization" do
    describe "acceptable options" do
      it "should accept proper initialization string" do
        lambda {klass.new('square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17')}.should_not raise_error
      end
      it "should accept a single size" do
        lambda {klass.new('medium:4x14')}.should_not raise_error
      end
    end
    describe "unacceptable options" do
      it "should throw exception when given non-recognized size" do
        lambda {klass.new('square:1x11,howdy:2x12')}.should raise_error(ArgumentError)
      end
      it "should throw an exception when extra comma is provided" do
        lambda {klass.new('square:1x11,thumbnail:3x2,')}.should raise_error(ArgumentError)
      end
    end
  end

  describe ":available_sizes" do
    it "should respond to :available_sizes" do
      subject.should respond_to(:available_sizes)
    end
    it "should return proper list of available sizes" do
      subject.available_sizes.should == expected_sizes.map(&:to_sym)
    end
  end

  describe "methods that return various sizes" do
    it "should respond to various sizes" do
      expected_sizes.each do |size|
        subject.should respond_to(size)
      end
    end
    it "should return proper dimensions for square" do
      index = 0
      expected_sizes.each do |size|
        subject.send(size).width.should eql(expected_dimensions[index][0])
        subject.send(size).height.should eql(expected_dimensions[index][1])
        index +=1
      end
    end
  end

  describe ":each" do
    it "should respond to :each" do
      subject.should respond_to(:each)
    end
    it "should yield sizes" do
      index = 0
      subject.  each do |size|
        size.should eql(expected_sizes[index])
        index+=1
      end
    end
  end

  describe ":each_with_dimensions" do
    it "should respond to :each_with_dimensions" do
      subject.should respond_to(:each_with_dimensions)
    end
    it "should yield expected results" do
      index =0
      subject.each_with_dimensions do |size,dimensions|
        size.should eql(expected_sizes[index])
        dimensions.width.should eql(expected_dimensions[index][0])
        dimensions.height.should eql(expected_dimensions[index][1])
        index+=1
      end
    end
  end

  describe ":each_dimensions_string" do
    it "should respond to :each_dimensions_string" do
      subject.should respond_to(:each_dimensions_string)
    end
    it "should yield proper strigns" do
      index=0
      subject.each_dimensions_string do |string|
        string.should eql("#{expected_sizes[index]} (#{expected_dimensions[index][0]}x#{expected_dimensions[index][1]})")
        index +=1
      end
    end
  end

  describe "self.regexp_size" do
    it "should accept proper strings" do
      klass.regexp_size.match('square:1x11,thumbnail:2x12').should_not be_nil
    end
    it "should not accept extraneous commas" do
      klass.regexp_size.match('square:1x11,thumbnail:2x12,').should be_nil
    end
    it "should not accept missing colons" do
      klass.regexp_size.match('square1x11,thumbnail:2x12').should be_nil
    end
  end

  describe "self.valid_size?" do
    it "should return false on bogus symbol" do
      klass.valid_size?(:bogus).should eql(false)
    end
    it "should return false on bogus string" do
      klass.valid_size?('bogus').should eql(false)
    end
    it "should return true on valid sizes provided as symbol" do
      expected_sizes.each do |size|
        klass.valid_size?(size.to_sym).should eql(true)
      end
    end
      it "should return true on valid sizes provided as string" do
      expected_sizes.each do |size|
        klass.valid_size?(size.to_s).should eql(true)
      end
    end
  end

  describe "valid dimensions" do
    it "should respond to :valid_dimensions?" do
      klass.should respond_to(:valid_dimensions?)
    end
    it "should accept a single size" do
      klass.valid_dimensions?('thumbnail:2x12').should be(true)
    end
    it "should accept multiple sizes" do
      klass.valid_dimensions?('square:1x11,thumbnail:2x12').should be(true)
    end
    it "should not accept missing colons" do
      klass.valid_dimensions?('square1x11,thumbnail:2x12').should be(false)
    end
    it "should not accept strings with extra commas" do
      klass.valid_dimensions?('square1x11,thumbnail:2x12,').should be(false)
    end
    it "should give false on unrecognized sizes" do
      klass.valid_dimensions?('square:1x11,garbage:2x3,thumbnail:4x5').should be(false)
    end
  end

  describe "to_s method" do
    it "should respond to to_s" do
      subject.should respond_to(:to_s)
    end
    it "should return proper to_s string" do
      subject.to_s.should eql(dimensions_string)
    end
  end

  describe "initialize_copy" do
    it "should have a independent @sizes attribute"do
      subject.sizes.__id__.should_not eq(subject.clone.sizes.__id__)
    end
    it "should have an independent @sizes elements" do
      other = subject.clone
      subject.sizes.keys.each do |key|
        subject.sizes[key].__id__.should_not eq(other.sizes[key].__id__)
      end
    end
  end

  describe ":==" do
    it "should == to itself" do
      subject.should eq(subject)
    end
    it "should == its clone" do
      subject.should eq(subject.clone)
    end
    it "should not == its clone if a single element is different" do
      other = subject.clone
      other.sizes[:square].stubs(:width).returns(77123)
      subject.should_not eq(other)
    end
  end

end

