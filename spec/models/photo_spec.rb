require 'spec_helper'

describe APP::Models::Photo do
  let(:models){APP::Models}
  let(:klass){models::Photo}
  let(:fixtures){APP::Fixtures.instance}
  let(:basic_photo){klass.new fixtures.photo}
  let(:extended_photo){klass.new fixtures.photo_details}


  subject {basic_photo}

  context "initialize" do
    context "with extended photo" do
      it "returns object of proper class" do
        klass.new(fixtures.photo_details).should be_a(models::Photo)
      end
    end

    context "with basic photo" do
      subject {klass.new fixtures.photo}
      it "returns object of proper class" do
        klass.new(fixtures.photo).should be_a(models::Photo)
      end
    end
    context "with nil" do
      it "raises error" do
        expect { klass.new nil}.to raise_error(ArgumentError)
      end
    end
    context "with FlickRaw::ResponseList class" do
      it "raises error" do
        expect { klass.new fixtures.photos}.to raise_error(ArgumentError)
      end
    end
    context "with an Array class" do
      it "raises error" do
        expect { klass.new []}.to raise_error(ArgumentError)
      end
    end
  end

  context "instance methods" do
    specify {subject.should respond_to(:photo_id)}
    context "#photo_id" do
      it "returns correct photo_id" do
        subject.photo_id.should == subject.id
      end
    end

    specify {subject.should respond_to(:usable?)}
    context "#usable?" do
      context "licenses that DO NOT reserve ALL copyright" do
        it "returns false when license is '0'" do
          subject.stub(:license).and_return("0")
          subject.should_not be_usable
        end
      end
      context "licenses that DO NOT allow for commercial usage" do
        it "returns false when license is '1'" do
          subject.stub(:license).and_return("1")
          subject.should_not be_usable
        end
        it "returns false when license is '2'" do
          subject.stub(:license).and_return("2")
          subject.should_not be_usable
        end
        it "returns false when license is '3'" do
          subject.stub(:license).and_return("3")
          subject.should_not be_usable
        end
      end
      context "licenses that allow for commercial usage" do
        it "returns false when license is '4'" do
          subject.stub(:license).and_return('4')
          subject.should be_usable
        end
        it "returns false when license is '5'" do
          subject.stub(:license).and_return('5')
          subject.should be_usable
        end
        it "returns false when license is '6'" do
          subject.stub(:license).and_return('6')
          subject.should be_usable
        end
      end
    end

    context "url image helpers" do
      context "basic photo" do
        subject {basic_photo}
        it_behaves_like "object with flickr image url helpers"
      end

      context "extended photo" do
        subject {extended_photo}
        it_behaves_like "object with flickr image url helpers"
      end
      
      context "#original" do
        context "basic photo" do
          subject  {basic_photo}
          specify {subject.should respond_to(:original)}
          it "returns nil for basic photo" do
            subject.original.should be_nil
          end
        end        
        context "extended photo" do
          subject  {extended_photo}
          specify {subject.should respond_to(:original)}
          it "returns expected url for detail photo" do
            subject.original.should == subject.square.sub('_%s_s.' % subject.secret, '_%s_o.' % subject.originalsecret)
          end
        end
      end
    end
    
    specify {subject.should respond_to(:owner_url)}
    context "#owner_url" do
      it "returns expected url link for owner of image" do
        subject.owner_url.should == "http://www.flickr.com/photos/#{fixtures.photo['owner']}/#{fixtures.photo['id']}"
      end
    end

    specify {subject.should respond_to(:owner_id)}
    context "#owner_id" do
      it "returns expected value id for owner of image" do
        subject.owner_id.should == fixtures.photo['owner']
      end

    end

    specify {subject.should respond_to(:owner)}
    context "#owner" do
      it "returns expected name for owner of image" do
        subject.owner.should == fixtures.photo['owner']
      end
    end

    specify{subject.should respond_to(:==)}
    context "#==" do
      subject {basic_photo}
      context "basic photo" do
        it "returns true when object is compared to itself" do
          subject.should == subject
        end
        it "returns true when object is compared to clone of itself" do
          subject.should == subject.clone
        end

        it "returns true when object is compared to an object of another class" do
          subject.should_not == [1,2,3,4]
        end
        it "returns true when object is compared to another object with slight difference" do
          subject.delegated_instance_methods.find_all do |value| value != :flickr_type end.each do |method|
            other = subject.clone
            value = case subject.send(method)
            when String then Faker::Lorem.sentence(3)
            when Fixnum then next
            else Random.rand
            end
            other.instance_eval('@delegated_to_object').instance_eval('@h[method.to_s]=value')
            subject.should_not == other
          end
        end
      end

      context "detailed photo" do
        subject {extended_photo}

        it "returns true when object is compared to itself" do
          subject.should == subject
        end
        it "returns true when object is compared to clone of itself" do
          subject.should == subject.clone
        end
        it "returns true when object is compared to an object of another class" do
          other = subject.clone
          other.instance_eval('@delegated_to_object').instance_eval('@h["dates"]').instance_eval('@h["taken"]="boobooje"')
          subject.should_not == other
        end

        it "returns true when object is compared to another object with slight difference" do
          subject.delegated_instance_methods.find_all do |value| value != :flickr_type end.each do |method|
            other = subject.clone
            value = case subject.send(method)
            when String then Faker::Lorem.sentence(3)
            when Fixnum then next
            else Random.rand
            end
            other.instance_eval('@delegated_to_object').instance_eval('@h[method.to_s]=value')
            subject.should_not == other
          end
        end
      end
    end

  end


  context "metaprogramming methods" do
    context "#delegated_instance_methods" do
      context "basic photo" do
        subject {basic_photo}
        it "returns methods for basic photos" do
          subject.delegated_instance_methods.sort.should == fixtures.expected_methods.photo.sort
        end
      end
      context "detailed photo" do
        subject {extended_photo}
        it "returns methods for extended photos" do
          subject.delegated_instance_methods.sort.should == fixtures.expected_methods.photo_details.sort
        end
      end

    end

    context "#respond_to?" do
      context "basic photo" do
        subject {basic_photo}
        it "responds to methods that are delegated to basic photo object" do
          fixtures.expected_methods.photo.each do |method|
            subject.should respond_to(method)
          end
        end
        it "responds to all methods returned by #methods" do
          subject.methods.each do |method|
            subject.should respond_to(method)
          end
        end
      end

      context "detailed photo" do
        subject {extended_photo}
        it "responds to methods that are delegated to detailed photo object" do
          fixtures.photo_details.methods(false).push(:flickr_type).each do |method|
            subject.should respond_to(method)
          end
        end
        it "responds to all methods returned by #methods" do
          subject.methods.each do |method|
            subject.should respond_to(method)
          end
        end
      end
    end

    context "#methods" do
      context "basic photo" do
        subject {basic_photo}

        specify {subject.should respond_to(:methods)}
        it "returns expected methods including delegated methods for basic photo fixture" do
          expected_methods = fixtures.expected_methods.photo + subject.old_methods
          (subject.methods - expected_methods).should be_empty
          subject.methods.length.should == expected_methods.length
        end
      end
      context "detailed photo" do
        subject {extended_photo}
        specify {subject.should respond_to(:methods)}
        it "returns expected methods including delegated methods to photo details fixture" do
          expected_methods = fixtures.expected_methods.photo_details + subject.old_methods
          (subject.methods - expected_methods).should be_empty
          subject.methods.length.should == expected_methods.length
        end
      end
    end

  end

  context "custom cloning methods" do
    context "#initialize_copy" do
      it "returns photo objects that have distinct @delegated_to_object ids from cloned object" do
        other = subject.clone
        subject.instance_eval("@delegated_to_object.__id__").should_not == other.instance_eval("@delegated_to_object.__id__")
      end
    end
  end
end
