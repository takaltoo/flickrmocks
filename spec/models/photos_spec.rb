require 'spec_helper'

describe APP::Photos do
  let(:api) {APP::Api}
  let(:klass) {APP::Photos}
  let(:fixtures){APP::Fixtures.new}
  let(:photo_fixture) {fixtures.photos}

  subject {klass.new fixtures.photos}
  let(:max_pages){subject.default(:max_entries)/subject.default(:per_page)}

  describe "self.defaults instance variables" do
    before(:each) do
      @defaults = klass.defaults.clone
    end
    after(:each) do
      klass.defaults = @defaults
    end
    it "should respond to :defaults" do
      klass.should respond_to(:defaults)
    end
    it "should be able to get/set default attributes" do
      klass.defaults.keys.each do |key|
        setter = (key.to_s + '=').to_sym
        value = klass.defaults.send(:[],key)
        expected = value*2
        klass.defaults.send(:[]=,key,expected)
        klass.defaults.send(:[],key).should == expected
      end
    end
    describe "max_entries" do
      it "should contain a max_entries key" do
        klass.defaults.should have_key(:max_entries)
      end
      it "should return proper :max_entries" do
        klass.defaults[:max_entries].should == 4000
      end
    end
    describe "per_page" do
      it "should contain :per_page key" do
        klass.defaults.should have_key(:per_page)
      end
      it "should have proper default for :per_page" do
        klass.defaults[:per_page].should == 50
      end
    end  
  end


  describe "default method" do
    it "should respond to :default" do
      subject.should respond_to(:default)
    end
    it "should be able to get default keys as string" do
      klass.defaults.each_pair do |key,value|
        subject.default(key.to_s).should == value
      end
    end
    it "should be able to get default keys as symbol" do
      klass.defaults.each_pair do |key,value|
        subject.default(key.to_sym).should == value
      end
    end
  end


  describe "current_page" do
    it "should respond to :current_page" do
      subject.should respond_to(:current_page)
    end
    it "should give correct value" do
      subject.current_page.should == photo_fixture.page
    end
  end
  
  describe "per_page" do
    it "should respond to :per_page" do
      subject.should respond_to(:per_page)
    end
    it "should give correct :per_page" do
      subject.per_page.should == photo_fixture.perpage
    end
  end

  describe "perpage" do
    it "should respond to :perpage" do
      subject.should respond_to(:perpage)
    end
    it "should give correct :perpage" do
      subject.perpage.should == photo_fixture.perpage
    end
  end
  
  describe ":total_entries" do
    it "should respond to :total_entries" do
      subject.should respond_to(:total_entries)
    end
    it "should properly return :total_entries" do
      subject.total_entries.should == photo_fixture.total.to_i
    end
  end

  


  
  describe ":max_entries" do
    it "should respond to :max_entries" do
      subject.should respond_to(:max_entries)
    end
    it "should return proper max_entries" do
      subject.max_entries.should == subject.default(:max_entries)
    end
  end
  
  describe ":photos" do
    it "should respond to :photos" do
      subject.should respond_to(:photos)
    end
    it "should return :photos" do
      subject.photos.should be_instance_of(Array)
    end
    it "should contain elements of proper class" do
      subject.photos.each do |photo|
        photo.should be_instance_of(APP::Photo)
      end
    end
    it "should contain correct number of photos" do
      subject.photos.length.should == fixtures.photos.map(&:id).length
    end
  end

  describe ":capped?" do
    it "should respond to :capped?" do
      subject.should respond_to(:capped?)
    end
    it "should return true when not all entries returned in search" do
      subject.stub(:total_entries).and_return(subject.default(:max_entries)+1)
      subject.should be_capped
    end
    it "should return false when not all entries are capped" do
      subject.stub(:total_entries).and_return(subject.default(:max_entries))
      subject.should_not be_capped
    end
  end

  describe ":each" do
    it "should respond to :each" do
      subject.should respond_to(:each)
    end
    it "should yield the photos" do
      index = 0
      subject.each do |photo|
        photo.should == subject.photos[index]
        index +=1
      end
    end
  end

  describe ":first" do
    it "should respond to :first" do
      subject.should respond_to(:first)
    end
    it "should return the first photo" do
      subject.first.should == subject.photos[0]
    end
  end

  describe ":last" do
    it "should respond to :last" do
      subject.should respond_to(:last)
    end
    it "should return last photo" do
      subject.last.should == subject.photos[-1]
    end
  end

  describe ":[]" do
    it "should respond to :[]" do
      subject.should respond_to(:[])
    end
    it "should be able to properly index all elements" do
      index = 0
      subject.each do |elem|
        subject[index].should == elem
        index +=1
      end
    end
  end

  describe "pages" do
    it "should limit total pages if greater than max_pages" do
      subject.stub(:total_pages).and_return(max_pages+20)
      subject.pages.should == max_pages
    end
    it "should return total pages if not greater than max_pages" do
      pages = max_pages() - 1
      subject.stub(:total_pages).and_return(pages)
      subject.pages.should == pages
    end
  end

  describe "initialize_copy" do
    it "should have a different photo_id on cloned object" do
      other = subject.clone
      index = 0
      subject.photos.each do |photo|
        photo.__id__.should_not == other.photos[index].__id__
        index += 1
      end
    end
  end

  describe "==" do
    it "should respond to :==" do
      subject.should respond_to(:==)
    end
    it "should be :== to itself" do
      subject.should == subject
    end
    it "should be :== to clone of itself" do
      subject.should == subject.clone
    end
    it "should not == random class" do
      subject.should_not == [1,2,3,4]
    end
    it "should not == nil" do
      subject.should_not == nil
    end

    it "should not equal class when single element of one photo is different" do
      other = subject.clone
      other.photos.last.instance_eval('@__delegated_to_object__').instance_eval('@h["farm"]=1234321')
      subject.should_not == other
    end
  end

  describe "size" do
    it "should respond to :size" do
      subject.should respond_to(:size)
    end
    it "should give the correct size" do
      subject.size.should == subject.photos.size
    end
  end

end
