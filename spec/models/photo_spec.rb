require 'spec_helper'

describe APP::Photo do
  let(:klass){APP::Photo}
  let(:fixtures){APP::Fixtures.new}
  let(:photo_fixture){fixtures.photo}
  let(:photo_detail_fixture){fixtures.photo_details}
  let(:subject){klass.new photo_fixture}
  
  describe "delegated methods" do
    describe "basic photo" do
      let(:subject){klass.new photo_fixture}
      let(:expected_methods){fixtures.expected_methods.photo}

      it "should be object of the proper class" do
        subject.should be_a(klass)
      end
      it "should respond properly to all delegated methods" do
        expected_methods.each do |method|
          subject.send(method).should eq(photo_fixture.send(method))
        end
      end
    end

    describe "extended photo" do
      let(:subject){klass.new photo_detail_fixture}
      let(:expected_methods){fixtures.expected_methods.photo_details}

      it "should be of object of proper class" do
        subject.should be_a(klass)
      end
      it "should respond properly to all delegated methods" do
        expected_methods.each do |method|
          subject.send(method).should eq(photo_detail_fixture.send(method))
        end
      end
    end
  end

  describe "photo url methods" do
    let(:base_url){"http://farm#{photo_fixture['farm']}.static.flickr.com/#{photo_fixture['server']}/#{photo_fixture['id']}_#{photo_fixture['secret']}"}
    it "should return :square url" do
      subject.square.should eql("#{base_url}_s.jpg")
    end
    it "should return :thumbnail url" do
      subject.thumbnail.should eql("#{base_url}_t.jpg")
    end
    it "should return :small url" do
      subject.small.should eql("#{base_url}_m.jpg")
    end
    it "should return :medium url" do
      subject.medium.should eql("#{base_url}.jpg")
    end
    it "should return :large url" do
      subject.large.should eql("#{base_url}_b.jpg")
    end
    it "should return :medium_640 url" do
      subject.medium_640.should eql("#{base_url}_z.jpg")
    end
    it "should return :medium 640 url" do
      subject.send(:'medium 640').should eql("#{base_url}_z.jpg")
    end
  end

  describe "owner_url" do
    it "should respond to :owner_url" do
      subject.should respond_to(:owner_url)
    end
    it "should return proper :owner_url" do
      subject.owner_url.should eql("http://www.flickr.com/photos/#{photo_fixture['owner']}/#{photo_fixture['id']}")
    end
  end

  describe "owner_id" do
    it "should respond to :owner_id" do
      subject.should respond_to(:owner_id)
    end
    it "should return :owner_id" do
      subject.owner_id.should eql(photo_fixture['owner'])
    end
  end

  describe "owner" do
    it "should respond to :owner" do
      subject.should respond_to(:owner)
    end
    it "should return :owner" do
      subject.owner.should eql(photo_fixture['owner'])
    end
  end

  describe "metaprogramming methods" do
    describe "with basic photo" do
      let(:subject) {klass.new(photo_fixture)}

      describe ":respond_to?" do
        it "should respond to all basic methods" do
          photo_fixture.methods(false).push(:flickr_type).each do |method|
            subject.should respond_to(method)
          end
        end
      end

      describe "public_methods" do
        it "should include all basic methods" do
          (photo_fixture.methods(false).push(:flickr_type) - subject.public_methods).should be_empty
        end
        it "should not include extended methods" do
          (photo_detail_fixture.methods(false).push(:flickr_type) - subject.public_methods).should_not be_empty
        end
      end

      describe "delegated_methods" do
        it "should include all basic methods" do
          photo_fixture.methods(false).push(:flickr_type).sort.should eq(subject.delegated_methods.sort)
        end
      end
    end

    describe "with detailed photo" do
      let(:subject) {klass.new(photo_detail_fixture)}

      describe "respond_to?" do
        it "should respond to all detailed photos" do
          photo_detail_fixture.methods(false).push(:flickr_type).each do |method|
            subject.should respond_to(method)
          end
        end
      end
      describe "public_methods" do
        it "should inlcude all extended methods" do
          (photo_detail_fixture.methods(false).push(:flickr_type) - subject.public_methods).should be_empty
        end
      end

      describe "delegated_methods" do
        it "should include all extended methods" do
          photo_detail_fixture.methods(false).push(:flickr_type).sort.should eq(subject.delegated_methods.sort)
        end
      end
    end
  end

  describe "==" do
    describe "basic photo" do
      it "should equal itself" do
        subject.should eq(subject)
      end
      it "should be equal to clone of itself" do
        subject.should eq(subject.clone)
      end

      it "should not be equal to an object of a different class" do
        subject.should_not eq([1,2,3,4])
      end
      it "should be not be equal if single element different" do
        subject.delegated_methods.find_all do |value| value != :flickr_type end.each do |method|
          other = subject.clone

          value = case subject.send(method)
          when String then Faker::Lorem.sentence(3)
          when Fixnum then next
          else subject.send(method)
          end
          other.instance_eval('@__delegated_to_object__').instance_eval('@h[method.to_s]=value')
          subject.should_not eq(other)
        end
      end
    end

    describe "detailed photo" do
      let(:subject){klass.new photo_detail_fixture}

      it "should equal itself" do
        subject.should eq(subject)
      end
      it "should be equal to clone of itself" do
        subject.should eq(subject.clone)
      end
      it "should be equal if single element different" do
       other = subject.clone
       other.instance_eval('@__delegated_to_object__').instance_eval('@h["dates"]').instance_eval('@h["taken"]="boobooje"')
       subject.should_not eq(other)      
      end
    end
    
  end

  describe "initialize_copy" do
    it "should have a @__delegated_to_object__ that is distinct when cloned" do
      other = subject.clone
      subject.instance_eval("@__delegated_to_object__.__id__").should_not eq(other.instance_eval("@__delegated_to_object__.__id__"))
    end
  end
  
end
