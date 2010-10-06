require 'spec_helper'

describe APP::CustomCompare do
  let(:fixtures){APP::Fixtures.new}

  let(:photo){fixtures.photo}
  let(:photos){fixtures.photos}
  let(:photo_details){fixtures.photo_details}
  let(:photo_sizes){fixtures.photo_sizes}
  let(:photo_size){fixtures.photo_size}

  describe "photo" do
    it "should be equal to itself" do
      photo.should eq(photo)
    end
    it "should not be equal to nil" do
      photo.should_not eq(nil)
    end
    it "should be equal to clone of itself" do
      photo.should eq(photo.clone)
    end
    it "should not equal a different class" do
      photo.should_not eq([1,2,3,4])
    end
    it "should not equal another of same class" do
      photo.should_not eq(photo_size)
    end
    it "should not equal when single element is different" do
      other = photo.clone
      other.stubs(:title).returns(Faker::Lorem.sentence(3))
      photo.should_not eq(other)
    end
  end

  describe "photos" do
    it "should equal itself" do
      photos.should eq(photos)
    end
    it "should equal clone of itself" do
      photos.should eq(photos.clone)
    end
    it "should not eq another response list" do
      photos.should_not eq(photo_sizes)
    end
    it "should not eq nil" do
      photos.should_not eq(nil)
    end
    it "should not eq itself with one field difference" do
      other = photos.clone
      other.stubs(:total).returns('123454321')
      photos.should_not eq(other)
    end
  end

  describe "photo_details" do
    it "should equal itself" do
      photo_details.should eq(photo_details)
    end
    it "should equal clone of itself" do
      photo_details.should eq(photo_details.clone)
    end
    it "should not eq nil" do
      photo_details.should_not eq(nil)
    end
    it "should not eq random class" do
      photo_details.should_not eq([1,2,3,4])
    end
    it "should not eq itself with a single element different" do
      other = photo_details.clone
      photo_details.stubs(:farm).returns(123421)
      photo_details.should_not eq(other)
    end
    it "should not eq another response" do
      photo_details.should_not eq(photo)
    end
  end

  describe "photo_sizes" do
    it "should equal itself" do
      photo_sizes.should eq(photo_sizes)
    end
    it "should eq clone of itself" do
      photo_sizes.should eq(photo_sizes.clone)
    end
    it "should not eq random class" do
      photo_sizes.should_not eq([1,2,3,4])
    end
    it "should not eq itself with single element difference" do
      other = photo_sizes.clone
      other.stubs(:canprint).returns(1234321)
      photo_sizes.should_not eq(other)
    end
  end

  describe "photo_size" do
    it "should equal itself" do
      photo_size.should eq(photo_size)
    end
    it "should equal clone of itself" do
      photo_size.should eq(photo_size.clone)
    end
    it "should not equal random class" do
      photo_size.should_not eq([1,2,3,4])
    end
    it "should not eq itself with single element difference" do
      other = photo_size.clone
      other.stubs(:width).returns(1234321)
      photo_size.should_not eq(other)
    end
  end



end