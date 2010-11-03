require 'spec_helper'

describe APP::PhotoSize do
  let(:klass){APP::PhotoSize}
  let(:fixtures){ APP::Fixtures.new}
  let(:size_fixture){fixtures.photo_size}

  subject {klass.new size_fixture}

  context "#initialize" do
    context "size fixture" do
      it "returns object of proper class" do
        subject.should be_a(APP::PhotoSize)
      end
    end
    context "FlickRaw::ResponseList object" do
      it "raises error" do
        expect {
          klass.new(fixtures.photos)
        }.to raise_error(ArgumentError)
      end
    end
    context "unexpected object" do
      it "raises error when array object provided" do
        expect{
          klass.new([])
        }.to raise_error(ArgumentError)
      end
      it "raises error when Hash object provided" do
        expect{
          klass.new({})
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "instance methods" do
    specify {subject.should respond_to(:size)}
    describe "#size" do
      it "should return proper size" do
        subject.size.should == size_fixture.label.downcase.sub('_',' ').to_s
      end
    end

    specify {subject.should respond_to(:id)}
    describe "#id" do
      it "should return proper :id" do
        subject.id.should == size_fixture.source.split('/')[-1].split('_')[0]
      end
    end

    specify {subject.should respond_to(:secret)}
    describe "#secret" do
      it "should return :secret" do
        subject.secret.should == size_fixture.source.split('/')[-1].split('_')[1]
      end
    end


    specify{subject.should respond_to(:==)}
    context "#==" do
      it "returns true when object is compared to clone of itself" do
        subject.should == subject.clone
      end
      it "returns true when object is compared to an array" do
        subject.should_not == [1,2,3,4]
      end
      it "returns false when compared to object that is different in one attribute" do
        subject.delegated_instance_methods do |method|
          value = case subject.send(method)
          when String then Faker::Lorem.sentence(3)
          when FixNum then Random.rand
          else Random.rand
          end
          other = subject.clone
          other.stub(method).returns(value)
          subject.should_not == other
        end
      end
    end
  end

  context "metaprogramming methods" do

    context "#delegated_instance_methods" do
      it "should delegate to FlickRaw::Response" do  
        subject.delegated_instance_methods.sort.should == fixtures.expected_methods.photo_size.sort
      end
    end

    context "#respond_to?" do
      it "returns true when given on of delegated_instance methods" do
        subject.delegated_instance_methods.each do |method|
          subject.should respond_to(method)
        end
      end
      it "returns true when given expected methods" do
        subject.methods do |method|
          subject.should respond_to(method)
        end
      end
    end

    context "#methods" do
      it "returns list that includes the methods that are delegated" do
        expected_methods = subject.old_methods + fixtures.expected_methods.photo_size
        (subject.methods - expected_methods).should be_empty
        subject.methods.length.should == expected_methods.length
      end

    end
  end
  
  context "custom cloning methods" do
    context "#initialize_copy" do
      it "returns photo object that have distinct __id__ as compared with original" do
        other = subject.clone
        subject.instance_eval('@delegated_to_object.__id__').should_not == other.instance_eval('@delegated_to_object.__id__')
      end
    end
  end
end
