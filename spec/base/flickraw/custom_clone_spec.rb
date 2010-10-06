require 'spec_helper'

describe APP::CustomClone do
  let(:fixtures){APP::Fixtures.new}

  let(:photo){fixtures.photo}
  let(:photos){fixtures.photos}
  let(:photo_details){fixtures.photo_details}
  let(:photo_sizes){fixtures.photo_sizes}
  let(:photo_size){fixtures.photo_size}

  def same_ids?(object,other)
    case object
    when FlickRaw::Response then same_ids?(object.instance_eval('@h'), other.instance_eval('@h'))
    when Fixnum then nil
    when String then object.__id__ == other.__id__
    when Array then object.each_with_index.map do |value,index|
        same_ids?(value,other[index])
      end.keep_if do |value|
        !value.nil?
      end.inject(true) do |previous,current|
        previous && current
      end
    when Hash then object.keys.map do |key|
        same_ids?(object[key],other[key])
      end.keep_if do |value|
        !value.nil?
      end.inject(true) do |previous,current|
        previous && current
      end
    end
  end

  describe "photo" do
    it "should have distinct id for clone" do
      other = photo.clone
      same_ids?(photo,other).should be_false
    end
    it "should have same id with itself" do
      same_ids?(photo,photo).should be_true
    end
  end

  describe "photos" do
    it "should have __id__ that is unique for clone"  do
      other = photos.clone
      same_ids?(photo,other).should be_false
    end
    it "should have same id with itself" do
      same_ids?(photo,photo)
    end
  end

  describe "photo_details" do
    it "should have id that is unique for clone" do
      other = photo_details.clone
      same_ids?(photo_details,other).should be_false
    end
    it "should have same id with itself" do
      same_ids?(photo_details,photo_details).should be_true
    end
  end

  describe "photo_sizes" do
    it "should have id that is unique for clone" do
      other  = photo_sizes.clone
      same_ids?(photo_sizes,other).should be_false
    end
    it "should have same id with itself" do
      same_ids?(photo_sizes,photo_sizes)
    end
  end

  describe "photo_size" do
    it "should have id that is unique for clone" do
      other = photo_size.clone
      same_ids?(photo_size,other).should be_false
    end
    it "should have same id with itself" do
      same_ids?(photo_size,photo_size)
    end
  end


end