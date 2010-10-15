require 'spec_helper'

describe APP::PhotoSize do
    let(:klass){APP::PhotoSize}
    let(:fixtures){ APP::Fixtures.new}
    let(:size_fixture){fixtures.photo_size}
    let(:expected_methods){fixtures.expected_methods.photo_size}
    let(:size){klass.new size_fixture}


  describe "class" do
    it "should return a proper class" do
      size.class.should == klass
    end
  end

  describe "size" do
    it "Should respond to :size" do
      size.should respond_to :size
    end
    it "should return proper size" do
      size.size.should == size_fixture.label.downcase.sub('_',' ').to_s
    end
  end

  describe "id" do
    it "should respond to :id" do
      size.should respond_to :id
    end
    it "should return proper :id" do
      size.id.should == size_fixture.source.split('/')[-1].split('_')[0]
    end
  end

  describe "secret" do
    it "should respond :secret" do
      size.should respond_to :secret
    end
    it "should return :secret" do
      size.secret.should == size_fixture.source.split('/')[-1].split('_')[1]
    end
  end

  describe "delegation methods" do
    it "should delegate to FlickRaw::Response" do
      expected_methods.each do |method|
        size.send(method).should == size_fixture.send(method)
      end
    end
  end

  describe "==" do

    it "should be == to clone of itself" do
      size.should == size.clone
    end
    it "should not == to another class" do
      size.should_not == [1,2,3,4]
    end
    it "should detect a single attribute error" do

      APP::PhotoSize.delegated_methods do |method|
        value = case size.send(method)
        when String then Faker::Lorem.sentence(3)
        when FixNum then Random.rand
        else size.send(method)
        end
        other = size.clone
        other.stub(method).returns(value)
        size.should_not == other
      end
    end
  end

  describe "clone" do
    it "should be have unique ids compared to clone" do
      subject = size
      other = subject.clone
      subject.instance_eval('@__delegated_to_object__.__id__').should_not == other.instance_eval('@__delegated_to_object__.__id__')
    end
  end

end
