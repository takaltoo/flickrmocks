require 'spec_helper'

describe APP::PhotoSizes do
  let(:klass){APP::PhotoSizes}
  let(:fixtures){APP::Fixtures.instance}

  subject {APP::PhotoSizes.new fixtures.photo_sizes}

  context "initialize" do
    context "with FlickRaw::ResponseList" do
      it "returns object of proper class" do
        klass.new(fixtures.photo_sizes).should be_a(APP::PhotoSizes)
      end
    end
    context "with FlickRaw::Response" do
      it "raises an error" do
        expect {
          klass.new(fixtures.photo)
        }.to raise_error(ArgumentError)

      end
    end
    context "with an Array object" do
      it "raises an error" do
        expect {
          klass.new([])
        }.to raise_error(ArgumentError)
      end
    end
    context "with a nil object" do
      it "raises an error" do
        expect {
          klass.new(nil)
        }.to raise_error(ArgumentError)
      end
    end
  end
  
  context "instance methods" do
    specify {subject.should respond_to(:id)}
    context "#id" do
      it "returns id for expected photo" do
        subject.id.should == fixtures.photo_size.source.split('/')[-1].split('_')[0]
      end
    end

    specify {subject.should respond_to(:secret)}
    context "#secret" do
      it "returns secret for correct photo" do
        subject.secret.should == fixtures.photo_size.source.split('/')[-1].split('_')[1]
      end
    end

    specify {subject.should respond_to(:sizes)}
    context "#sizes" do
      it "returns array of PhotoSize objects" do
        subject.sizes.should == subject.map do |size| size end
      end
    end

    specify {subject.should respond_to(:available_sizes)}
    context "#available_sizes" do
      it "returns array of sizes availalbe" do
        subject.available_sizes.should == subject.sizes.map do |size|
          size.size.to_sym
        end
      end
    end

    specify {subject.should respond_to(:possible_sizes)}
      context "possible_sizes" do
        it "returns list of sizes that are possible for an image" do
          subject.possible_sizes == FlickrMocks::Models::Helpers.possible_sizes
        end
    end
    specify {subject.should respond_to(:to_s)}
    context "#to_s" do
      it "should return expected string" do
        expected = subject.map do |size| "#{size.label.downcase.sub(' ','_')}:#{size.width}x#{size.height}" end.join(',')
        subject.to_s.should == expected
      end
    end

    specify {subject.should respond_to(:==)}
    describe "#==" do
      it "returns true when object is compared to itself" do
        subject.should == subject
      end
      it "returns true when object is compared to clone of itself" do
        subject.should == subject.clone
      end
      it "returns false when object is compared to Fixnum" do
        subject.should_not == 2
      end
      it "returns false when object is compared to Array" do
        subject.should_not == []
      end
      it "returns false when object compared to object with only a single difference" do
        other = subject.clone
        other[0].instance_eval('@delegated_to_object').instance_eval('@h["label"] = "random size"')
        subject.should_not == other
      end
    end

    context "#collection" do

      specify { subject.should respond_to(:collection)}
      context "#collection" do
        let(:reference){
          OpenStruct.new :current_page => 1,
          :per_page => subject.available_sizes.length,
          :total_entries => subject.available_sizes.length,
          :collection => subject.sizes
        }
        it_behaves_like "object that responds to collection"
      end
    end
  end

  context "metaprogramming methods" do

    specify{subject.should respond_to(:delegated_instance_methods)}
    context "#delegated_instance_methods" do
      it "returns array accessor methods + size methods" do
        subject.delegated_instance_methods.sort.should == (subject.possible_sizes +
                                                                           APP::Models::Helpers.array_accessor_methods).sort
      end
    end

    specify{subject.should respond_to(:methods)}
    context "#methods" do
      it "returns all methods including those that are delegated" do
        subject.methods.sort.should == ( subject.delegated_instance_methods +
            subject.old_methods).sort
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
      let(:reference) {subject.sizes}
      it_behaves_like "object with delegated Array accessor helpers"
    end

  end

  context "custom cloning methods" do
    context "initialize_copy" do
      it "returns clone with distinct id from original object" do
        other = subject.clone
        subject.each_index do |index|
          subject[index].__id__.should_not == other[index].__id__
        end
      end
    end
  end
  
end



