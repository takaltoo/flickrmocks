require 'spec_helper'

describe APP::Models::CommonsInstitutions do
  let(:api) {APP::Api}
  let(:models){APP::Models}
  let(:klass) {models::CommonsInstitutions}
  let(:fixtures){APP::Fixtures.instance}
  let(:fixture){fixtures.commons_institutions}
  subject {klass.new(fixture)}


  context "class methods" do
    specify { klass.should respond_to(:defaults)}
    it "returns expected set of defaults" do
      klass.defaults.should == models::Helpers.paging_defaults
    end
  end

  context "initialization" do
    it "returns object of a proper class when photos FlickRaw::ResponseList provided" do
      klass.new(fixture).class.should == klass
    end
    it "raises an error when FlickRaw::Response provided" do
      expect {klass.new(fixtures.photo)}.to raise_error(ArgumentError)
    end
    it "raises an error when an Array class specified" do
      expect {klass.new([1,3,4])}.to raise_error(ArgumentError)
    end
  end

  context "instance methods" do
    specify {subject.should respond_to(:default)}
    context "#default" do
      it "should return default when proper symbol provided" do
        klass.defaults.keys.each do |symbol|
          subject.default(symbol).should == klass.defaults[symbol]
        end
      end
      it "should return default when proper string provided" do
        klass.defaults.keys.each do |symbol|
          subject.default(symbol.to_s).should == klass.defaults[symbol]
        end
      end
      it "should return nil when 'garbage' provided" do
        subject.default(:garbage).should == nil
      end
    end

    context "paging methods" do
      specify {subject.should respond_to(:current_page)}
      context "#current_page" do
        it "should return 1 when no current_page given at initialization" do
          klass.new(fixture,:per_page => 20).current_page.should == 1
        end
        it "should return specified current_page is valid" do
          klass.new(fixture,:per_page => 20, :current_page => 2).current_page.should == 2
        end
        it "should return 1 when current page is 0" do
          klass.new(fixture,:per_page => 20, :current_page => 0).current_page.should == 1
        end
        it "should return max page when current_page is greater than max_page" do
          max_page = (fixture.size / 20.to_f).ceil
          klass.new(fixture,:per_page => 20,
                                  :current_page => max_page+1).current_page.should == max_page
        end
        it "should return 1 when :per_page is very large and current_page is not set" do
          klass.new(fixture,:per_page => 200000).current_page.should == 1
        end
      end

      specify {subject.should respond_to(:per_page)}
      context "#per_page" do
        it "returns default per_page when none specified at initialization" do
          klass.new(fixture,:current_page => 1).per_page.should ==
            FlickrMocks::Models::Helpers.paging_defaults[:per_page]
        end
        it "returns per_page value that was specified during initialization" do
          klass.new(fixture,:per_page => 33, :current_page => 1).per_page.should == 33
        end
        it "returns 1 when per_page is set to 0" do
          klass.new(fixture,:per_page => 0, :current_page => 1).per_page.should ==
                             FlickrMocks::Models::Helpers.paging_defaults[:per_page]
        end
      end

      specify {subject.should respond_to(:total_entries)}
      context "#total_entries" do
        it "returns expected number of photos" do
          subject.total_entries.should == fixtures.commons_institutions.size
        end
      end

      specify {subject.should respond_to(:==)}
      context "#==" do
        subject{klass.new(fixture,:per_page => 20, :current_page => 1)}
        it "returns true when object compared to itself" do
          subject.should == subject
        end
        it "returns true when object compared to clone of itself" do
          subject.should == subject.clone
        end
        it "returns false when object is compared to object with different :per_page" do
          subject.should_not == klass.new(fixture, :per_page => subject.per_page + 1,
                                                    :current_page => subject.current_page)
        end
        it "returns false when object is compared to object with different :current_page" do
          subject.should_not == klass.new(fixture,:per_page => subject.per_page,
            :current_page => subject.current_page + 1)
        end
      end
    end
  end

  context "metaprogramming methods" do
    specify{ subject.should respond_to(:delegated_instance_methods)}
    context "#delegated_instance_methods" do
      it "returns expected list of methods that are delegated to other objects" do
        subject.delegated_instance_methods.sort.should == (FlickrMocks::Models::Helpers.array_accessor_methods).sort
      end
    end

    specify { subject.should respond_to(:methods)}
    context "#methods" do
      it "should return all methods as well as array iteration methods" do
        subject.methods.sort.should == (subject.old_methods + subject.delegated_instance_methods).sort
      end
    end

    specify{ subject.should respond_to(:respond_to?)}
    context "#respond_to?" do
      it "recognizes all methods returned by #methods" do
        subject.methods.each do |method|
          subject.should respond_to(method)
        end
      end
    end

    context "iteratable methods" do
      let(:reference) {subject.instance_eval('@delegated_to_object')}
      it_behaves_like "object with delegated Array accessor helpers"
    end

    specify {subject.should respond_to(:collection)}
    context "#collection" do
      context "usable argument set to nil" do
        let(:subject){
          klass.new(fixture,:per_page => 20, :current_page => 1)
        }
        let(:reference){
          OpenStruct.new :current_page => 1,
          :per_page => 20,
          :total_entries => fixture.size,
          :collection => subject.institutions[0,20]
        }
        it_behaves_like "object that responds to collection"
      end
    end
  end

    context "custom cloning methods" do
      context "#initialize_copy" do
        it "returns institution objects that have distinct ids from the cloned object" do
          other = subject.clone
          subject.each_index do |index|
            subject[index].__id__.should_not == other[index].__id__
          end
        end
      end
    end
end

