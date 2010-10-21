require 'spec_helper'

describe APP::Photo do
  let(:klass){APP::Photo}
  let(:fixtures){APP::Fixtures.new}
  let(:photo_fixture){fixtures.photo}
  let(:photo_detail_fixture){fixtures.photo_details}

  subject {klass.new photo_fixture}

  context "delegated methods" do
    context "basic photo" do
      subject {klass.new photo_fixture}
      let(:expected_methods){fixtures.expected_methods.photo}

      it "should be object of the proper class" do
        subject.should be_a(klass)
      end
      it "should respond properly to all delegated methods" do
        expected_methods.each do |method|
          subject.send(method).should ==photo_fixture.send(method)
        end
      end
    end

    context "extended photo" do
      subject {klass.new photo_detail_fixture}
      let(:expected_methods){fixtures.expected_methods.photo_details}

      it "should be of object of proper class" do
        subject.should be_a(klass)
      end
      it "should respond properly to all delegated methods" do
        expected_methods.each do |method|
          subject.send(method).should == photo_detail_fixture.send(method)
        end
      end
    end
  end

  context "url_methods" do
    it "should respond to :url_methods" do
      subject.should respond_to(:url_methods)
    end
    it "should return expected methods" do
      subject.url_methods.sort.should == [:square,:thumbnail,:small,:medium,
        :large,:medium_640,:owner_url].sort
    end
  end

  context "photo url methods" do
    let(:base_url){"http://farm#{photo_fixture['farm']}.static.flickr.com/#{photo_fixture['server']}/#{photo_fixture['id']}_#{photo_fixture['secret']}"}
    it "should return :square url" do
      subject.square.should == "#{base_url}_s.jpg"
    end
    it "should return :thumbnail url" do
      subject.thumbnail.should == "#{base_url}_t.jpg"
    end
    it "should return :small url" do
      subject.small.should == "#{base_url}_m.jpg"
    end
    it "should return :medium url" do
      subject.medium.should == "#{base_url}.jpg"
    end
    it "should return :large url" do
      subject.large.should == "#{base_url}_b.jpg"
    end
    it "should return :medium_640 url" do
      subject.medium_640.should == "#{base_url}_z.jpg"
    end
    it "should return :medium 640 url" do
      subject.send(:'medium 640').should == "#{base_url}_z.jpg"
    end
  end

  context "owner_url" do
    it "should respond to :owner_url" do
      subject.should respond_to(:owner_url)
    end
    it "should return proper :owner_url" do
      subject.owner_url.should == "http://www.flickr.com/photos/#{photo_fixture['owner']}/#{photo_fixture['id']}"
    end
  end

  context "owner_id" do
    it "should respond to :owner_id" do
      subject.should respond_to(:owner_id)
    end
    it "should return :owner_id" do
      subject.owner_id.should == photo_fixture['owner']
    end
  end

  context "owner" do
    it "should respond to :owner" do
      subject.should respond_to(:owner)
    end
    it "should return :owner" do
      subject.owner.should == photo_fixture['owner']
    end
  end

  context "metaprogramming methods" do
    context "with basic photo" do
      subject {klass.new(photo_fixture)}

      context ":respond_to?" do
        it "should respond to all basic methods" do
          photo_fixture.methods(false).push(:flickr_type).each do |method|
            subject.should respond_to(method)
          end
        end
      end

      context "public_methods" do
        it "should include all basic methods" do
          (photo_fixture.methods(false).push(:flickr_type) - subject.public_methods).should be_empty
        end
        it "should not include extended methods" do
          (photo_detail_fixture.methods(false).push(:flickr_type) - subject.public_methods).should_not be_empty
        end
      end

      context "delegated_methods" do
        it "should include all basic methods" do
          photo_fixture.methods(false).push(:flickr_type).sort.should == subject.delegated_methods.sort
        end
      end
    end

    context "with detailed photo" do
      subject {klass.new(photo_detail_fixture)}

      context "respond_to?" do
        it "should respond to all detailed photos" do
          photo_detail_fixture.methods(false).push(:flickr_type).each do |method|
            subject.should respond_to(method)
          end
        end
      end
      context "public_methods" do
        it "should inlcude all extended methods" do
          (photo_detail_fixture.methods(false).push(:flickr_type) - subject.public_methods).should be_empty
        end
      end

      context "delegated_methods" do
        it "should include all extended methods" do
          photo_detail_fixture.methods(false).push(:flickr_type).sort.should == subject.delegated_methods.sort
        end
      end
    end
  end

  context "==" do
    context "basic photo" do
      it "should equal itself" do
        subject.should == subject
      end
      it "should be equal to clone of itself" do
        subject.should == subject.clone
      end

      it "should not be equal to an object of a different class" do
        subject.should_not == [1,2,3,4]
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
          subject.should_not == other
        end
      end
    end

    context "detailed photo" do
      subject {klass.new photo_detail_fixture}

      it "should equal itself" do
        subject.should == subject
      end
      it "should be equal to clone of itself" do
        subject.should == subject.clone
      end
      it "should be equal if single element different" do
        other = subject.clone
        other.instance_eval('@__delegated_to_object__').instance_eval('@h["dates"]').instance_eval('@h["taken"]="boobooje"')
        subject.should_not == other
      end
    end
    
  end

  context "initialize_copy" do
    it "should have a @__delegated_to_object__ that is distinct when cloned" do
      other = subject.clone
      subject.instance_eval("@__delegated_to_object__.__id__").should_not == other.instance_eval("@__delegated_to_object__.__id__")
    end
  end

  context "photo_id" do
    it "should respond to :photo_id" do
      subject.should respond_to(:photo_id)
    end
    it "should give correct photo_id" do
      subject.photo_id.should == subject.id
    end
  end
  
end
