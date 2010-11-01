require 'spec_helper'


describe APP::Photos do
  let(:api) {APP::Api}
  let(:klass) {APP::Photos}
  let(:fixtures){APP::Fixtures.new}
  let(:photo_fixture) {fixtures.photos}

  subject {klass.new fixtures.photos}
  let(:max_pages){subject.default(:max_entries)/subject.default(:per_page)}

  context "class methods" do 
    specify { klass.should respond_to(:defaults)}
    
    context "defaults" do
      before(:each) do
        @defaults = klass.defaults.clone
      end
      after(:each) do
        klass.defaults = @defaults
      end
      specify {klass.defaults.should have_key(:max_entries)}
      specify {klass.defaults.should have_key(:per_page)}

      it "should behave like a Hash" do
        klass.defaults.keys.each do |key|
          setter = (key.to_s + '=').to_sym
          value = klass.defaults.send(:[],key)
          expected = value*2
          klass.defaults.send(:[]=,key,expected)
          klass.defaults.send(:[],key).should == expected
        end
      end
    end   
  end

  context "class instance variables" do    
    context "@defaults" do
      specify { klass.defaults.should have_key(:max_entries) }
      specify { klass.defaults.should have_key(:per_page) }
      
      it "returns 50 for argument :per_page" do
        klass.defaults[:per_page].should == 50
      end
      it "returns 4000 for argument :max_entries" do
        klass.defaults[:max_entries].should == 4000
      end
    end
  end

  context "instance methods" do

    specify {  subject.should respond_to(:default) }
    context "#default" do
      it "accepts a string for argument" do
        klass.defaults.each_pair do |key,value|
          subject.default(key.to_s).should == value
        end
      end
      it "accepts a symbol for argument" do
        klass.defaults.each_pair do |key,value|
          subject.default(key.to_sym).should == value
        end
      end
      it "returns 50 for :per_page" do
        subject.default(:per_page).should == klass.defaults[:per_page]
      end
      it "returns 4000 for :max_entries" do
        subject.default(:max_entries).should == klass.defaults[:max_entries]
      end
    end

    specify {  subject.should respond_to(:current_page) }
    context "#current_page" do
      it "returns expected page" do
        subject.current_page.should == photo_fixture.page
      end
      it "returns kind of type Fixnum" do
        subject.current_page.should be_a(Fixnum)
      end
    end

    specify {  subject.should respond_to(:per_page) }
    describe "#per_page" do
      it "returns maximum entries possible for a page" do
        subject.per_page.should == photo_fixture.perpage
      end
      it "returns kind of Fixnum" do
        subject.per_page.should be_a(Fixnum)
      end
    end

    specify {  subject.should respond_to(:perpage) }
    describe "#perpage" do
      it "returns maximum entries possible for a page" do
        subject.perpage.should == photo_fixture.perpage
      end
      it "returns kind of Fixnum" do
        subject.perpage.should be_a(Fixnum)
      end
    end

    specify { subject.should respond_to(:total_entries) }
    describe "#total_entries" do
      it "returns total of photos" do
        subject.total_entries.should == photo_fixture.total.to_i
      end
      specify{ subject.total_entries.should be_a(Fixnum)}
    end

    specify {subject.should respond_to(:capped_entries)}
    describe "#capped_entries"  do
      it "returns total_entries when total_entries <= max_entries" do
        subject.stub(:total_entries).and_return(subject.max_entries)
        subject.capped_entries.should == subject.total_entries
      end
      it "returns max_entries when total_entries > max_entries" do
        subject.stub(:total_entries).and_return(subject.max_entries + 200)
        subject.capped_entries.should < subject.total_entries
        subject.capped_entries.should == subject.max_entries
      end
    end

    specify { subject.should respond_to(:max_entries) }
    describe "#max_entries" do
      it "returns maximum possible entries returned by flickr" do
        subject.max_entries.should == subject.default(:max_entries)
      end
      it "returns kind of Fixnum" do
        subject.max_entries.should be_a(Fixnum)
      end
    end

    specify { subject.should respond_to(:pages) }
    describe "#pages" do
      it "limits the number of pages when total_pages > max_pages" do
        subject.stub(:total_pages).and_return(max_pages+20)
        subject.pages.should == max_pages
      end
      it "returns total pages when total_pages <= max_pages" do
        pages = max_pages() - 1
        subject.stub(:total_pages).and_return(pages)
        subject.pages.should == pages
      end
      it "returns kind of Fixnum" do
        subject.pages.should be_a(Fixnum)
      end
    end

    specify {  subject.should respond_to(:capped?) }
    describe "#capped?" do
      it "returns true when partial number of entries returned" do
        subject.stub(:total_entries).and_return(subject.default(:max_entries)+1)
        subject.should be_capped
      end
      it "returns false when all entries returned" do
        subject.stub(:total_entries).and_return(subject.default(:max_entries))
        subject.should_not be_capped
      end
    end

    specify { subject.should respond_to(:photos) }
    describe "#photos" do
      it "returns kind of Array" do
        subject.photos.should be_an(Array)
      end
      it "returns Array containing elements of class FlickrMocks::Photo " do
        subject.photos.each do |photo|
          photo.should be_instance_of(APP::Photo)
        end
      end
      it "returns expected number of photos" do
        subject.photos.length.should == fixtures.photos.map(&:id).length
      end
    end


    specify {subject.should respond_to(:==)}
    context "#==" do
      it "returns true when comparing object to self" do
        subject.should == subject
      end
      it "returns true when comparing object to clone of self" do
        subject.should == subject.clone
      end
      it "returns false when object compared to random object" do
        subject.should_not == [1,2,3,4]
      end
      it "returns false when object compard to nil" do
        subject.should_not == nil
      end
      it "returns false when object compared to object that is different in only one element" do
        other = subject.clone
        other.photos.last.instance_eval('@delegated_to_object').instance_eval('@h["farm"]=1234321')
        subject.should_not == other
      end
    end

    specify {subject.should respond_to(:collection)}
    context "#collection" do
      specify{subject.collection.should be_a(WillPaginate::Collection)}
      it "returns object with expected current_page value" do
        subject.collection.current_page.should == subject.current_page
      end
      it "returns object with expected per_page value" do
        subject.collection.per_page.should == subject.per_page
      end
      it "returns object with expected total_entries" do
        subject.collection.total_entries.should == subject.capped_entries
      end
    end

    context "meta-programming" do
      specify{ subject.should respond_to(:delegated_instance_methods)}
      specify{ subject.should respond_to(:respond_to?)}
      context "#delegated_instance_methods" do
        it "returns expected list of methods that are delegated to other objects" do
          subject.delegated_instance_methods.should == APP::Photos.delegated_instance_methods
        end
      end

      context "#respond_to?" do
        it "recognizes all methods returned by #methods" do
          subject.methods.each do |method|
            subject.should respond_to(method)
          end
        end
      end
      context "iteratable methods" do
        let(:reference) {subject.photos}
        it_behaves_like "object with delegated Array accessor helpers"
      end
    end

    context "custom cloning methods" do
      context "#initialize_copy" do
        it "returns photo objects that have distinct ids from the cloned object" do
          other = subject.clone
          index = 0
          subject.photos.each do |photo|
            photo.__id__.should_not == other.photos[index].__id__
            index += 1
          end
        end
      end
    end
  end

end
