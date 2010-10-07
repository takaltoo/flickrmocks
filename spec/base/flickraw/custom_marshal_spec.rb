require 'spec_helper'

describe APP::CustomMarshal do
  let(:klass) {APP::CustomMarshal}
  let(:helpers) {APP::Helpers}
  let(:fixtures) {APP::Fixtures.new}

  shared_examples_for "any object wrapper" do
    it "should properly marshal/unmarshal Photos object" do
      marshalled = Marshal.load(Marshal.dump(subject))
      helpers.equivalent?(subject,marshalled).should be_true
    end
  end

  context "Photos" do
    let(:subject){fixtures.photos}
    it_behaves_like "any object wrapper"
  end

  context "PhotoSizes" do
    let(:subject){fixtures.photo_sizes}
    it_behaves_like "any object wrapper"
  end
  
  context "PhotoDetails" do
    let(:subject){fixtures.photo_details}
    it_behaves_like "any object wrapper"
  end

  context "Photo" do
    let(:subject){fixtures.photo}
    it_behaves_like "any object wrapper"
  end

  context "InterestingPhotos" do
    let(:subject){fixtures.interesting_photos}
    it_behaves_like "any object wrapper"
  end

end

