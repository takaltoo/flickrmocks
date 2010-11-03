require 'spec_helper'

describe APP::PhotoDimensions do
  let(:dimensions_string) {'square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17'}
  let(:expected_sizes) { [:square, :thumbnail, :small, :medium,:medium_640, :large, :original] }
  let(:klass) {APP::PhotoDimensions}

  subject { APP::PhotoDimensions.new(dimensions_string) }

  context "class methods" do
    specify {klass.should respond_to(:regexp_size)}
    context "regexp_size" do
      it "returns match when provided with valid string such as: 'square:1x11,thumbnail:2x12'" do
        klass.regexp_size.match('square:1x11,thumbnail:2x12').should_not be_nil
      end
      it "returns nil when string contains an extra comma" do
        klass.regexp_size.match('square:1x11,thumbnail:2x12,').should be_nil
      end
      it "returns nil when string is missing a comma" do
        klass.regexp_size.match('square1x11,thumbnail:2x12').should be_nil
      end
    end
  end
  
  context "initialize" do
    context "valid initialization strings" do
      it "returns object of proper class with valid string" do
        klass.new('square:1x11,thumbnail:2x12,small:3x13,medium:4x14,medium_640:5x15,large:6x16,original:7x17').class.should == klass
      end
      it "returns object of proper class with string containing only a single dimension" do
        klass.new('medium:4x14').class.should == klass
      end
    end
    
    context "initialization with invalid arguments" do
      it "raises exception when string contains invalid size" do
        lambda {klass.new('square:1x11,howdy:2x12')}.should raise_error(ArgumentError)
      end
      it "raises exception when string contains extraneous comma" do
        lambda {klass.new('square:1x11,thumbnail:3x2,')}.should raise_error(ArgumentError)
      end
      it "raises exception when argument does not respond to to_s method" do
        lambda {klass.new('square:1x11,thumbnail:3x2'.stub(:to_s).and_return(nil))}.should raise_error(ArgumentError)
      end
    end
  end

  context "instance methods" do
    specify {subject.should respond_to(:available_sizes)}
    context "#available_sizes" do
      it "returns list of available sizes" do
        subject.available_sizes.should == expected_sizes
      end
    end

    specify {subject.should respond_to(:collection)}
    context "#collection" do
      let(:reference){
        OpenStruct.new :current_page => 1,
        :per_page => subject.available_sizes.length,
        :total_entries => subject.available_sizes.length,
        :collection => subject.dimensions
      }
      it_behaves_like "object that responds to collection"
    end

    specify {subject.should respond_to(:to_s)}
    describe "#to_s method" do
      it "returns expected string that represents the size and dimensions of the photo" do
        subject.to_s.should == dimensions_string
      end
    end

    specify {subject.should respond_to(:==)}
    context "#==" do
      it "returns true when object compared to itself" do
        subject.should == subject
      end
      it "returns true when object compared to clone of itself" do
        subject.should == subject.clone
      end
      it "returns false when single element is different" do
        other = subject.clone
        other.first.width=77123
        subject.should_not == other
      end
    end

    specify {subject.should respond_to(:possible_sizes)}
    context "#possible_sizes" do
      it "returns expected set of sizes" do
        subject.possible_sizes.should == FlickrMocks::Models::Helpers.possible_sizes
      end
    end


    context "size methods" do
      context "fully specified dimension" do
        let(:dimensions) {[[1,11],[2,12],[3,13],[4,14],[5,15],[6,16],[7,17]]}
        def reference
          index = expected_sizes.find_index(size)
          OpenStruct.new :size => size,
            :width => dimensions[index][0],
            :height => dimensions[index][1]
        end

        specify{subject.should respond_to(:square)}
        context "#square" do
          let(:size){:square}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:thumbnail)}
        context "#thumbnail" do
          let(:size){:thumbnail}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:small)}
        context "#small" do
          let(:size){:small}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:medium)}
        context "#medium" do
          let(:size){:medium}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:medium_640)}
        context "#medium_640" do
          let(:size){:medium_640}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:large)}
        context "#large" do
          let(:size){:large}
          it_behaves_like "object with size accessor"
        end

        specify{subject.should respond_to(:original)}
        context "#large" do
          let(:size){:original}
          it_behaves_like "object with size accessor"
        end
      end

      context "partially specified dimensions" do
        subject {APP::PhotoDimensions.new('square:1x11')}
        it "should return object for dimensions that are specified" do
          subject.send(:square).should_not be_nil
        end
        it "should return nil for dimensions that are not specified" do
          [:thumbnail, :small, :medium,:medium_640, :large, :original].each do |method|
            subject.send(method).should be_nil
          end
        end
      end
    end
    
    context "iteratable methods" do
      let(:reference){subject.dimensions}
      it_behaves_like "object with delegated Array accessor helpers"
    end

    
  end

  context "metapragramming methods" do
    specify {subject.should respond_to(:methods)}
    context "#methods" do
      it "returns expected set of methods" do
        subject.methods.sort.should == (subject.old_methods +
                                           subject.delegated_instance_methods +
                                           subject.possible_sizes).sort
      end
    end

    specify {subject.should respond_to(:respond_to?)}
    context "#respond_to?" do
      it "returns true with return value from methods" do
        subject.methods.each do |method|
          subject.should respond_to(method)
        end
      end

      specify {subject.should respond_to(:delegated_instance_methods)}
      context "#delegated_instance_methods" do
        it "returns methods that include array accessors" do
          subject.delegated_instance_methods.sort.should == ( 
              FlickrMocks::Models::Helpers.array_accessor_methods ).sort
        end
      end
    end
  end

  context "custom cloning methods" do
    context "#initialize_copy" do
      it "returns cloned object that has distinct id as compared with original"do
        subject.dimensions.each.map do |value| value.__id__ end.should_not ==
          subject.clone.dimensions.each.map do |value| value.__id__ end
      end
    end
  end
end

