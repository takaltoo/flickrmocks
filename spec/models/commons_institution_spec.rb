require 'spec_helper'

describe APP::Models::CommonsInstitution do
  let(:api) {APP::Api}
  let(:models){APP::Models}
  let(:klass) {models::CommonsInstitution}
  let(:fixtures){APP::Fixtures.instance}
  let(:fixture){fixtures.commons_institutions[0]}
  subject {klass.new(fixture)}

  context "initialization" do
    it "returns object of proper class when supplied FlickRaw::Response" do
      klass.new(fixture).class.should == klass
    end
    it "raises an error when FlickRaw::ResponseList is provided" do
      expect { klass.new(fixtures.photos)}.to raise_error
    end
    it "raises an Error when an Array is specified" do
      expect { klass.new([1,2,3,4])}.to raise_error
    end
  end
  
  context "instance methods" do

    specify {subject.should respond_to(:launch_date)}
    context "#launch_date" do
      it "returns expected launch date" do
        subject.launch_date.should == fixture.date_launch
      end
    end
    
    specify {subject.should respond_to(:owner_id)}
    context "#owner_id" do
      it "returns expected id for owner of photo" do
        subject.owner_id.should == fixture.nsid
      end
    end

    context "#owner" do
      it "returns expected id for owner of photo" do
        subject.owner.should == fixture.nsid
      end
    end

    specify {subject.should respond_to(:owner_name)}
    context "#owner_name" do
      it "returns expected owner_name" do
        subject.owner_name.should == fixture.name
      end
    end

    specify {subject.should respond_to(:site_url)}
    context "#site_url" do
      it "returns expected url for site owner" do
        subject.site_url.should == fixture.urls[0]['_content']
      end
    end

    specify {subject.should respond_to(:license_url)}
    context "#license_url" do
      it "returns expected url for license of photos" do
        subject.license_url.should == fixture.urls[1]['_content']
      end
    end

    specify {subject.should respond_to(:flickr_url)}
    context "#flickr_url" do
      it "returns expected url for institution on flickr" do
        subject.flickr_url.should == fixture.urls[2]['_content']
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
      it "returns flase when object is compared to identical object EXCEPT with one element" do
        subject.should_not == subject.clone.instance_eval('@delegated_to_object').instance_eval('@h["urls"][0].instance_eval("@h")["type"]="garbage"')
      end
      it "returns false when object is compared to random object" do
        subject.should_not == [1,2,3,4]
      end
      it "returns false when object is compared to another object of same calss" do
        subject.should_not == klass.new(fixtures.commons_institutions[1])
      end
    end
  end

  
  context "custom cloning" do
    context "#initialize_copy" do
      it "returns institution objects that have distinct ids from the cloned object" do
        other = subject.clone
        subject.instance_eval('@delegated_to_object').__id__.should_not == other.instance_eval('@delegated_to_object').__id__
      end
    end
  end

end
