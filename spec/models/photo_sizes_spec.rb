require 'spec_helper'

describe APP::PhotoSizes do
  let(:klass){APP::PhotoSizes}
  let(:fixtures){APP::Fixtures.new}

  let(:photo_sizes_fixture){fixtures.photo_sizes}
  let(:photo_size_fixture){fixtures.photo_size}

  let(:expected_methods){fixtures.expected_methods.photo_sizes}
  let(:subject){APP::PhotoSizes.new photo_sizes_fixture}
  

  describe ":class" do
    it "should return object of proper class" do
      subject.should be_instance_of(klass)
    end
  end

  describe ":available_sizes" do
    it "should respond to :available_sizes" do
      subject.should respond_to(:available_sizes)
    end
    it "should return all available_sizes" do
      subject.available_sizes.should ==
        subject.sizes.map(&:label).map(&:downcase).map do |m|  m.sub(" ","_") end.map(&:to_sym)
    end
  end
  describe "id" do
    it "should respond to :id" do
      subject.should respond_to(:id)
    end
    it "should give correct id" do
      subject.id.should eql(photo_size_fixture.source.split('/')[-1].split('_')[0])
    end
  end
  describe "secret" do
    it "should respond to :secret" do
      subject.should respond_to(:secret)
    end
    it "should give correct secret" do
      subject.secret.should eql(photo_size_fixture.source.split('/')[-1].split('_')[1])
    end
  end
  describe "first" do
    it "should respond to :first" do
      subject.should respond_to(:first)
    end
    it "should have proper first method" do
      subject.first.should eq(subject[0])
    end
  end

  describe "last" do
    it "should respond to :last" do
      subject.should respond_to(:last)
    end
    it "should have proper last method" do
      subject.last.should eq(subject[-1])
    end
  end

  describe ":'medium 640'" do
    it "should return a proper size :'medium 640'" do
      subject.send(:'medium 640').should_not be_nil
    end
    it ":'medium 640' should return same as :medium_640" do
      subject.send(:'medium 640').should eq(subject.send(:medium_640))
    end
  end

  describe "empty?"  do
    it "should respond to :empty?" do
      subject.should respond_to(:empty?)
    end
    it "should not be empty?" do
      subject.should_not be_empty
    end
  end

  describe "each" do
    let(:expected_methods){fixtures.expected_methods.photo_size}
    it "should respond to the :each method" do
      subject.should respond_to(:each)
    end
    it "should yield elements that respond to expected_methods" do
      subject.each do |size|
        expected_methods.each do |method|
          size.should respond_to(method)
        end
      end
    end
    it "should yield correct number of elements" do
      count = 0
      subject.each do |size|
        count+=1
      end
      count.should eq(photo_sizes_fixture.map(&:label).length)
    end
  end

  describe ":[]" do
    it "should respond to :[]" do
      subject.should respond_to(:[])
    end
    it "should be able to shadow each" do
      index = 0
      subject.each do |v|
        subject[index].should eq(v)
        index+=1
      end
    end
  end

  describe ":all" do
    it "should respond to method :all" do
      subject.should respond_to(:all)
    end
    it "should return the same object as :sizes" do
      subject.all.should eq(subject.sizes)
    end
  end

  describe ":sizes" do
    let(:expected_methods){fixtures.expected_methods.photo_size}
    
    it "should respond to :sizes method" do
      subject.should respond_to(:sizes)
    end

    it "should return array of PhotoSize" do
      subject.sizes.each do |size|
        expected_methods.each do |method|
          size.should respond_to(method)
        end
      end
    end
  end

  describe ":to_s" do
    it "should respond to :to_s method" do
      subject.should respond_to(:to_s)
    end
    it "should return expected string" do
      expected = subject.sizes.map do |size| "#{size.label.downcase.sub(' ','_')}:#{size.width}x#{size.height}" end.join(',')
      subject.to_s.should eql(expected)
    end
  end
end