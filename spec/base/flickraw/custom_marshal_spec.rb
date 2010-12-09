require 'spec_helper'

describe APP::CustomMarshal do
  let(:klass) {APP::CustomMarshal}
  let(:helpers) {APP::Helpers}
  let(:fixtures) {APP::Fixtures.instance}

  shared_examples_for "marshalling and unmarshalling flickraw objects" do
    it "should properly marshal/unmarshal Photos object" do
      marshalled = Marshal.load(Marshal.dump(subject))
      helpers.equivalent?(subject,marshalled).should be_true
    end
  end
  
  context "intance methods" do
    context "flickraw fixtures" do
      context "#marshal and #unmarshal" do
        context "fixture: photos" do
          let(:subject){fixtures.photos}
          it_behaves_like "marshalling and unmarshalling flickraw objects"
        end

        context "fixture: photo_sizes" do
          let(:subject){fixtures.photo_sizes}
          it_behaves_like "marshalling and unmarshalling flickraw objects"
        end

        context "fixture: photo_details" do
          let(:subject){fixtures.photo_details}
          it_behaves_like "marshalling and unmarshalling flickraw objects"
        end

        context "fixture: photo" do
          let(:subject){fixtures.photo}
          it_behaves_like "marshalling and unmarshalling flickraw objects"
        end

        context "fixture: interesting_photos" do
          let(:subject){fixtures.interesting_photos}
          it_behaves_like "marshalling and unmarshalling flickraw objects"
        end
      end
    end
  end
end