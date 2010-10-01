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
      size.size.should eql(size_fixture.label.downcase.sub('_',' ').to_s)
    end
  end

  describe "id" do
    it "should respond to :id" do
      size.should respond_to :id
    end
    it "should return proper :id" do
      size.id.should eql(size_fixture.source.split('/')[-1].split('_')[0])
    end
  end

  describe "secret" do
    it "should respond :secret" do
      size.should respond_to :secret
    end
    it "should return :secret" do
      size.secret.should eql(size_fixture.source.split('/')[-1].split('_')[1])
    end
  end

  describe "delegation methods" do
    it "should delegate to FlickRaw::Response" do
      expected_methods.each do |method|
        size.send(method).should eq(size_fixture.send(method))
      end
    end
  end

end
