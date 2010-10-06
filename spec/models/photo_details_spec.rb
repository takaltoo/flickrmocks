require 'spec_helper'

describe APP::PhotoDetails do
  
  let(:klass){APP::PhotoDetails}
  let(:fixtures){APP::Fixtures.new}

  let(:photo_fixture) {fixtures.photo}
  let(:photo_details_fixture) {fixtures.photo_details}
  let(:photo_sizes_fixture) {fixtures.photo_sizes}

  let(:extended_delegated_methods) {fixtures.expected_methods.photo_details}
  let(:delegated_methods) {fixtures.expected_methods.photo}

  let(:photo) { APP::Photo.new photo_fixture }
  let(:photo_details) { APP::Photo.new photo_details_fixture }
  let(:sizes) { APP::PhotoSizes.new fixtures.photo_sizes }

  let(:subject){ APP::PhotoDetails.new photo_details,sizes}


  describe "initialization" do
    describe "errors" do
      it "should raise error when wrong type supplied for photo" do
        lambda{APP::PhotoDetails.new [],sizes}.should raise_error ArgumentError
      end
      it "should raise error when wrong type specified for sizes" do
        lambda{APP::PhotoDetails.new photo_details,[]}.should raise_error ArgumentError
      end
    end
    describe "success" do
      it "should accept Photo object for photo" do
        lambda{APP::PhotoDetails.new photo_details,sizes}.should_not raise_error
      end
      it "should accept Flickr response for photo" do
        lambda{APP::PhotoDetails.new photo_details_fixture,sizes}.should_not raise_error
      end
      it "should accept PhotoSize for size" do
        lambda{APP::PhotoDetails.new photo_details,sizes}
      end
      it "should accept Flickr response for size" do
        lambda{APP::PhotoDetails.new photo_details,photo_sizes_fixture}.should_not raise_error
      end

    end
  end

  describe "delegation methods to photo" do
    it "should properly delegate to photo methods" do
      subject.delegated_methods.each do |method|
        subject.send(method).should eq(photo_details_fixture.send(method))
      end
    end
  end

  describe ":sizes method" do
    it "should respond to :sizes method" do
      subject.should respond_to(:sizes)
    end
    it "should yield objects that respond to expected methods" do
      subject.sizes.sizes.each do |size|
        fixtures.expected_methods.photo_size.each do |method|
          size.should respond_to(method)
        end
      end
    end
  end

  describe ":owner_name" do
    it "should respond to :owner_name" do
      subject.should respond_to(:owner_name)
    end
    it "should return proper :owner_name" do
      subject.owner_name.should eql(fixtures.photo_details.owner.realname)
    end
  end
  
  describe "owner_username" do
    it "should respond to :owner_username" do
      subject.should respond_to(:owner_username)
    end
    it "should return proper :owner_username" do
      subject.owner_username.should eql(fixtures.photo_details.owner.username)
    end
  end
  
  describe "original" do
    it "should respond to original" do
      subject.should respond_to(:original)
    end
  end

  describe "metaprogramming methods" do

    describe "extended photo" do
      describe "respond_to?" do
        it "should recognize delegated methods" do
          extended_delegated_methods.each do |method|
            subject.send(method).should eq(photo_details_fixture.send(method))
          end
        end
      end

      describe "delegated_methods" do
        it "should contain all methods from photo_details" do
          subject.delegated_methods.sort.should eq(extended_delegated_methods.sort)
        end
      end

      describe "public_methods" do
        it "should contain all methods from photo_details" do
          (extended_delegated_methods-subject.public_methods).should be_empty
        end
      end
    end

    describe "basic photo" do
      let (:subject) {APP::PhotoDetails.new photo,sizes}
      describe "respond_to?" do
        it "should recognize delegated methods" do
          delegated_methods.each do |method|
            subject.send(method).should eq(photo_fixture.send(method))
          end
        end
      end

      describe "delegated_methods" do
        it "should contain all methods from basic_photo" do
          (subject.delegated_methods - delegated_methods).should be_empty
        end
      end

      describe "public_methods" do
        it "should contain all of the delegated methods" do
          (subject.delegated_methods  - subject.public_methods).should be_empty
        end
      end
    end

    describe "clone" do
      it "should have independent @sizes" do
        subject.sizes.__id__.should_not eq(subject.clone.sizes.__id__)
      end
      it "should have an independent @__delegated_methods__" do
        subject.instance_eval("@__delegated_methods__.__id__").should_not eq(
          subject.clone.instance_eval("@__delegated_methods__.__id__"))
      end
      it "should have an independent @__delegated_to_object__" do
        subject.instance_eval("@__delegated_to_object__.__id__").should_not eq(
          subject.clone.instance_eval("@__delegated_to_object__.__id__")
        )
      end
    end

    describe ":==" do
      it "should be :== to itself" do
        subject.should eq(subject)
      end
      it "should be :== to its clone" do
        subject.should eq(subject.clone)
      end

      it "should not == when one of delegated_to methods is different" do
        other = subject.clone
        other.instance_eval('@__delegated_to_object__').instance_eval('@__delegated_to_object__').instance_eval('@h')["location"]["country"].instance_eval('@h["place_id"]="new old place"')
        subject.should_not eq(other)
        # should equal when subject also set to new value
        subject.instance_eval('@__delegated_to_object__').instance_eval('@__delegated_to_object__').instance_eval('@h')["location"]["country"].instance_eval('@h["place_id"]="new old place"')
        subject.should eq(other)
      end
    end

  end

end
