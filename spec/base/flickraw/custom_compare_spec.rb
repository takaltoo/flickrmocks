require 'spec_helper'

describe APP::CustomCompare do
  let(:fixtures){APP::Fixtures.instance}

  let(:photo){fixtures.photo}
  let(:photos){fixtures.photos}
  let(:photo_details){fixtures.photo_details}
  let(:photo_sizes){fixtures.photo_sizes}
  let(:photo_size){fixtures.photo_size}

  shared_examples_for "flickraw response for ==" do
    it "should be equal to itself" do
      subject.should == subject
    end
    it "should not be equal to nil" do
      subject.should_not == nil
    end
    it "should be equal to clone of itself" do
      subject.should == subject.clone
    end
    it "should not equal a different class" do
      subject.should_not == [1,2,3,4]
    end
    it "should not eq another response" do
      subject.should_not == other
    end
  end

  context "instance methods" do
    context "#==" do
      context "photo flickraw response" do
        let(:subject){photo}
        let(:other){photo_details}

        it_behaves_like  "flickraw response for =="

        it "returns false when object is compared with object that is slightly different" do
          other = subject.clone
          other.stub(:title).and_return(Faker::Lorem.sentence(3))
          subject.should_not == other
        end
      end

      context "photos flickraw responselist" do
        let(:subject){photos}
        let(:other){photo_details}

        it_behaves_like "flickraw response for =="

        it "returns false when object is compared with object that is slightly different" do
          other = subject.clone
          other.stub(:total).and_return('123454321')
          subject.should_not == other
        end
      end

      context "photo_details flickraw response" do
        let(:subject){photo_details}
        let(:other){photo_sizes}

        it_behaves_like "flickraw response for =="

        it "returns false when object is compared with object that is slightly different" do
            other = subject.clone
            other.stub(:farm).and_return(123421)
            subject.should_not == other
        end
      end

      context "photo_sizes response list" do
        let(:subject){photo_sizes}
        let(:other){photo_details}

        it_behaves_like "flickraw response for =="

        it "returns false when object is compared with object that is slightly different" do
          other = subject.clone
          other.stub(:canprint).and_return(1234321)
          subject.should_not == other
        end
      end

      context "photo_size response" do
        let(:subject){photo_size}
        let(:other){photo_details}

        it_behaves_like "flickraw response for =="

        it "returns false when object is compared with object that is slightly different" do
          other = subject.clone
          other.stub(:width).and_return(1234321)
          subject.should_not == other
        end
      end
    end
  end
end