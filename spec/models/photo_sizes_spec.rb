require 'spec_helper'

describe APP::PhotoSizes do
  let(:klass){APP::PhotoSizes}
  let(:fixtures){APP::Fixtures.new}

  let(:photo_sizes_fixture){fixtures.photo_sizes}
  let(:photo_size_fixture){fixtures.photo_size}

  let(:expected_methods){fixtures.expected_methods.photo_sizes}
  
  let(:photo_sizes_square){
        subject  = APP::PhotoSizes.new photo_sizes_fixture
        # Generate an object that DOES not have all the sizes to see if all sizes
        subject.instance_eval "@available_sizes = [:square]"
        subject.instance_eval "@sizes = [@sizes[0]]"
        subject
  }

  subject {APP::PhotoSizes.new photo_sizes_fixture}
  

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
      subject.id.should == photo_size_fixture.source.split('/')[-1].split('_')[0]
    end
  end
  describe "secret" do
    it "should respond to :secret" do
      subject.should respond_to(:secret)
    end
    it "should give correct secret" do
      subject.secret.should == photo_size_fixture.source.split('/')[-1].split('_')[1]
    end
  end
  describe "first" do
    it "should respond to :first" do
      subject.should respond_to(:first)
    end
    it "should have proper first method" do
      subject.first.should == subject[0]
    end
  end

  describe "last" do
    it "should respond to :last" do
      subject.should respond_to(:last)
    end
    it "should have proper last method" do
      subject.last.should == subject[-1]
    end
  end

  describe ":'medium 640'" do
    it "should return a proper size :'medium 640'" do
      subject.send(:'medium 640').should_not be_nil
    end
    it ":'medium 640' should return same as :medium_640" do
      subject.send(:'medium 640').should == subject.send(:medium_640)
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
      count.should == photo_sizes_fixture.map(&:label).length
    end
  end

  describe ":[]" do
    it "should respond to :[]" do
      subject.should respond_to(:[])
    end
    it "should be able to shadow each" do
      index = 0
      subject.each do |v|
        subject[index].should == v
        index+=1
      end
    end
  end

  describe ":all" do
    it "should respond to method :all" do
      subject.should respond_to(:all)
    end
    it "should return the same object as :sizes" do
      subject.all.should == subject.sizes
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
      subject.to_s.should == expected
    end
  end

  describe "meta-programming methods" do
    describe "methods" do
      it "should respond_to methods" do
        subject.should respond_to(:methods)
      end
      it "should return proer list of methods with fully specified object" do
        subject = klass.new(photo_sizes_fixture)
        (klass.possible_sizes - subject.methods).should be_empty
      end
      it "should return proper list of methods when not all sizes available" do
        (klass.possible_sizes - subject.methods).should be_empty
      end
    end
  end

  describe "klass.possible_sizes" do
    let(:possible_sizes){[:square, :thumbnail, :small, :medium, :medium_640, :large, :original]}

    it "should respond to method" do
      klass.should respond_to(:possible_sizes)
    end

    it "should return expected results" do
      (klass.possible_sizes - possible_sizes).should be_empty
      klass.possible_sizes.length.should == possible_sizes.length
    end

  end

  describe "size retrieval methods" do
    it "should return size for all available sizes" do
      index = 0
      subject.available_sizes.each do |size|
        subject.send(size).should == APP::PhotoSize.new(photo_sizes_fixture[index])
        index += 1
      end
    end
    it "should return nil for all sizes that are NOT available" do
      subject = photo_sizes_square
      (klass.possible_sizes -  photo_sizes_square.available_sizes).each do |size|
        subject.send(size).should be_nil
      end
    end
  end

  describe "==" do
    it "should be == to itself" do
      subject.should == subject
    end
    it "should be == to clone of itself" do
      subject.should == subject.clone
    end
    it "should not be equal to wrong class" do
      subject.should_not == 2
    end
    it "should not be equal if available sizes is different" do
      other = subject.clone
      other.stub(:available_sizes).and_return(subject.available_sizes[-1])
      subject.should_not == other
    end
    it "should not be equal if one element of the sizes object is different" do
      other = subject.clone
      other.sizes[0].instance_eval('@__delegated_to_object__').instance_eval('@h["label"] = "random size"')
      subject.should_not == other
    end

  end

  describe "initialize_copy" do
    it "should create a duplicate copy of @sizes" do
      other = subject.clone
      index = 0
      subject.each do |size|
        size.__id__.should_not == other[index].__id__
        index+=1
      end
    end
    it "should create a duplicate copy of @available_sizes" do
      other = subject.clone
      subject.available_sizes.__id__.should_not == other.available_sizes.__id__
    end
  end

  describe "size" do
    it "should respond to method :size" do
      subject.should respond_to(:size)
    end
    it "should return proper number of sizes" do
      subject.size.should == subject.all.size
    end
  end

end
