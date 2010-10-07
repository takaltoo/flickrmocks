require 'spec_helper'

describe APP::CustomCompare do
  let(:fixtures){APP::Fixtures.new}

  let(:photo){fixtures.photo}
  let(:photos){fixtures.photos}
  let(:photo_details){fixtures.photo_details}
  let(:photo_sizes){fixtures.photo_sizes}
  let(:photo_size){fixtures.photo_size}

  shared_examples_for "any flickraw response fixture" do
    it "should be equal to itself" do
      subject.should eq(subject)
    end
    it "should not be equal to nil" do
      subject.should_not eq(nil)
    end
    it "should be equal to clone of itself" do
      subject.should eq(subject.clone)
    end
    it "should not equal a different class" do
      subject.should_not eq([1,2,3,4])
    end
    it "should not eq another response" do
      subject.should_not eq(other)
    end
  end

  context "photo" do
    let(:subject){photo}
    let(:other){photo_details}

    it_behaves_like "any flickraw response fixture"

    it "should not equal when single element is different" do
      other = subject.clone
      other.stubs(:title).returns(Faker::Lorem.sentence(3))
      subject.should_not eq(other)
    end
  end

  context "photos" do
    let(:subject){photos}
    let(:other){photo_details}
    
    it_behaves_like "any flickraw response fixture"

    it "should not eq itself with one field difference" do
      other = subject.clone
      other.stubs(:total).returns('123454321')
      subject.should_not eq(other)
    end
  end

  context "photo_details" do
    let(:subject){photo_details}
    let(:other){photo_sizes}

    it_behaves_like "any flickraw response fixture"

    it "should not eq itself with a single element different" do
      other = subject.clone
      subject.stubs(:farm).returns(123421)
      subject.should_not eq(other)
    end
  end

   context "photo_sizes" do
    let(:subject){photo_sizes}
    let(:other){photo_details}

    it_behaves_like "any flickraw response fixture"

    it "should not eq itself with single element difference" do
      other = subject.clone
      other.stubs(:canprint).returns(1234321)
      subject.should_not eq(other)
    end
  end

  context "photo_size" do
    let(:subject){photo_size}
    let(:other){photo_details}

    it_behaves_like "any flickraw response fixture"

    it "should not eq itself with single element difference" do
      other = subject.clone
      other.stubs(:width).returns(1234321)
      subject.should_not eq(other)
    end
  end

end