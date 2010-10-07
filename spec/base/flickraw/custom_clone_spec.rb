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

  describe "clone" do
    shared_examples_for "cloning any flickraw response" do
      it "has distinct ids for clone" do
        other = subject.clone
        same_ids?(photo,other).should be_false
      end
      it "has same id with itself" do
        same_ids?(photo,photo).should be_true
      end
    end

    context "photo" do
      let(:subject){ photo}
      it_behaves_like "cloning any flickraw response"
    end

    context "photos" do
      let(:subject) { photos }
      it_behaves_like "cloning any flickraw response"
    end

    context "photo_details" do
      let(:subject) {photo_details}
      it_behaves_like "cloning any flickraw response"
    end

    context "photo_sizes" do
      let(:subject) { photo_sizes }
      it_behaves_like "cloning any flickraw response"
    end

    context "photo_size" do
      let(:subject) {photo_size}
      it_behaves_like "cloning any flickraw response"
    end
  end

end