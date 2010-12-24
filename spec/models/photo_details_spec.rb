require 'spec_helper'

describe APP::Models::PhotoDetails do
  let(:klass){APP::Models::PhotoDetails}
  let(:fixtures){APP::Fixtures.instance}
  let(:models){APP::Models}

  let(:basic_photo) { models::Photo.new fixtures.photo }
  let(:extended_photo) { models::Photo.new fixtures.photo_details }
  let(:photo_sizes) { models::PhotoSizes.new fixtures.photo_sizes }

  let(:photo_details_basic){klass.new(basic_photo,photo_sizes)}
  let(:photo_details_extended){klass.new(extended_photo,photo_sizes)}

  
  describe "initialization" do
    it "returns object of proper class when extended PhotoDetails and PhotoSizes supplied" do
      klass.new(extended_photo,photo_sizes).should be_a(klass)
    end
    it "returns object of proper class when basic PhotoDetails and PhotoSizes supplied" do
      klass.new(basic_photo,photo_sizes).should be_a(klass)
    end
    it "returns object of expected class when proper flickr responses supplied for sizes and photo" do
      klass.new(fixtures.photo_details,fixtures.photo_sizes).should be_a(klass)
    end
    it "raises an error when Array supplied for photo" do
      lambda{models::PhotoDetails.new [],photo_sizes}.should raise_error ArgumentError
    end
    it "raises an error when Array supplied for photo_details" do
      lambda{models::PhotoDetails.new extended_photo,[]}.should raise_error ArgumentError
    end
    it "raises error when nil supplied for photo_sizes" do
      lambda{models::PhotoDetails.new extended_photo,nil}.should raise_error ArgumentError
    end
    it "raises error when nil supplied for photo_details" do
      lambda{models::PhotoDetails.new nil,photo_sizes}.should raise_error ArgumentError
    end
  end

  context "instance methods" do
    subject {photo_details_extended}
    specify {subject.should respond_to(:owner_name)}
    context "#owner_name" do
      it "returns expected name for owner" do
        subject.owner_name.should == fixtures.photo_details.owner.realname
      end
    end

    specify {subject.should respond_to(:owner_username)}
    context "#owner_username" do
      it "returns expected name for owner" do
        subject.owner_username.should == fixtures.photo_details.owner.username
      end
    end


    specify {subject.should respond_to(:author)}
    context "#author" do
      it "returns owner_name when NOT empty" do
        subject.stub(:owner_name).and_return("Sample Owner")
        subject.author.should == subject.owner_name
      end
      it "returns owner_username when owner_name is NOT present" do
        subject.stub(:owner_name).and_return("")
        subject.author.should == subject.owner_username
      end
    end

    specify {subject.should respond_to(:dimensions)}
    context "#dimensions" do
      it "returns expected PhotoSize object" do
        subject.dimensions.should == photo_sizes
      end
    end

    specify {subject.should respond_to(:possible_sizes)}
    context "#possible_sizes" do
      it "returns list of all possible sizes" do
        subject.possible_sizes.should == FlickrMocks::Models::Helpers.possible_sizes
      end
    end

    specify {subject.should respond_to(:photo)}
    context "#photo" do
      it "returns expected Photo object when basic photo" do
        subject.photo.should == extended_photo
      end
    end

    specify {subject.should respond_to(:==)}
    context "#==" do
      it "returns true when object is compared to itself" do
        subject.should == subject
      end
      it "returns true when object is compared to clone of itself" do
        subject.should == subject.clone
      end
      it "returns false when object is compared to an Array" do
        subject.should_not == [1,2,3]
      end
      it "returns false when a single dimension is different" do
        other = subject.clone
        other.dimensions[0].instance_eval('@delegated_to_object').instance_eval('@h["width"]=-22')
        subject.should_not == other
      end
      it "returns false when a single photo attribute is different" do
        other = subject.clone
        subject.photo.instance_eval('@delegated_to_object').instance_eval('@h["farm"]=-22')
        subject.should_not == other
      end
    end

    context "methods that are delegated to photo object" do
      context "basic photo object" do
        subject {photo_details_basic}
        it "returns expected result delegated to non-url helpers for basic photo" do
          subject.photo.delegated_instance_methods.each do |method|
            subject.send(method).should == subject.photo.send(method)
          end
        end
      it "returns expected result delegated to url helpers for basic photo" do
          reference = models::Photo.new(fixtures.photo)
          FlickrMocks::Models::Helpers.possible_sizes.each do |size|
            subject.send(size).should == reference.send(size)
          end
      end
      end
      context "detailed photo object" do
        subject {photo_details_extended}
        eval('specify {subject.should respond_to(:id)}')
        it "returns expected result for basic delegated photos" do
          subject.photo.delegated_instance_methods.each do |method|
            subject.send(method).should == subject.photo.send(method)
          end
        end
        it "returns expected result delegated to url helpers for detailed photo" do
          reference = models::Photo.new(fixtures.photo_details)
          FlickrMocks::Models::Helpers.possible_sizes.each do |size|
            subject.send(size).should == reference.send(size)
          end
        end
      end
    end

    context "iteration methods delegated to dimensions (PhotoSizes)" do    
        let(:reference){photo_sizes}
        it_should_behave_like "object with delegated Array accessor helpers"
      end
  end


  context "metaprogramming methods" do    
    context "#respond_to?" do
      context "with basic photo" do
        subject {photo_details_basic}
        specify {subject.should respond_to(:respond_to?)}
        it "returns true for all methods including the ones that are delegated to sizes and basic photo" do
          subject.methods.each do |method|
            subject.should respond_to(method)
          end
        end
      end

      context "with extended photo" do
        subject {photo_details_extended}
        specify {subject.should respond_to(:respond_to?)}
        it "returns true for all methods including the ones that are delegated to sizes and extended photo" do
          subject.methods.each do |method|
            subject.should respond_to(method)
          end
        end
      end
    end

    context "#methods" do
      context "with basic photo" do
        subject {photo_details_basic}
        specify {subject.should respond_to(:methods)}
        it "resturns methods including those delegated to sizes and basic photo" do
          subject.methods.sort.should == (subject.old_methods + subject.delegated_instance_methods).sort
        end
      end

      context "with extended photo" do
        subject {photo_details_extended}
        specify {subject.should respond_to(:methods)}
        it "returns methods including those delegated to sizes and extended photo" do
          subject.methods.sort.should == (subject.old_methods + subject.delegated_instance_methods).sort
        end
      end
    end

    context "#delegated_instance_methods" do
      context "with basic photo" do
        subject {photo_details_basic}
        specify {subject.should respond_to(:delegated_instance_methods)}
        it "returns methods including those delegated to sizes and basic photo" do
          subject.delegated_instance_methods.sort.should ==  
            (subject.photo.delegated_instance_methods +
              FlickrMocks::Models::Helpers.array_accessor_methods +
              FlickrMocks::Models::Helpers.possible_sizes +
              [:owner_id]).sort
        end
      end
      context "with extended photo" do
        subject {photo_details_extended}
        specify {subject.should respond_to(:delegated_instance_methods)}
        it "returns methods including those delegated to sizes and extended photo" do
          subject.delegated_instance_methods.sort.should ==
            (subject.photo.delegated_instance_methods +
              FlickrMocks::Models::Helpers.array_accessor_methods +
              FlickrMocks::Models::Helpers.possible_sizes +
              [:owner_id]).sort
        end
      end
    end
  end


  context "custom cloning methods" do
    subject{photo_details_extended}
    context "#initialize_copy" do
      it "returns cloned object with distinct __id__ for dimensions" do
        subject.dimensions.__id__.should_not == subject.clone.dimensions.__id__
      end
      it "returns cloned object with distinct __id__ for photo" do
        subject.instance_eval('@delegated_to_object.__id__').should_not ==
          subject.clone.instance_eval('@delegated_to_object.__id__')
      end
    end
  end

end





