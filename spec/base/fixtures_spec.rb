require 'spec_helper'
require 'ruby-debug'
describe APP::Fixtures do
  let(:klass) {APP::Fixtures}
  let(:fixtures) {APP::Fixtures.new}

  describe "photos" do
    let(:subject) {fixtures.photos}
    let(:expected_methods){fixtures.expected_methods.photos}

    it "should respond to :photos" do
      fixtures.should respond_to(:photos)
    end
    it "returned object should be ResponseList class" do
      subject.should be_instance_of(FlickRaw::ResponseList)
    end
    it "should respond to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
    it "should contain photo elements that respond to photo methods" do
      subject.photo.each do |photo|
        fixtures.expected_methods.photo.each do |method|
          photo.should respond_to(method)
        end
      end
    end
  end

  describe ':interesting_photos' do
    let(:subject){fixtures.interesting_photos}
    let(:expected_methods){fixtures.expected_methods.interesting_photos}

    it "should respond to interesting_photos" do
      fixtures.should respond_to(:interesting_photos)
    end
    it "should return an object that responds to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
    describe ":photo" do
      let(:subject) {fixtures.interesting_photos.photo}
      let(:expected_methods){fixtures.expected_methods.photo}
      it "should yield an object that responds to :each" do
        subject.should respond_to(:each)
      end
      it "should yield objects that respond to proper methods" do
        subject.each do |photo|
          expected_methods.each do |method|
            photo.should respond_to(method)
          end
        end
      end
    end
  end

  describe ":author_photos" do
    let(:subject){fixtures.author_photos}
    let(:expected_methods){fixtures.expected_methods.author_photos}

    it "should respond to :author_photos" do
      fixtures.should respond_to(:author_photos)
    end
    it "should return an object that responds to the expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
    describe ":photo" do
      let(:expected_methods){fixtures.expected_methods.photo}
      let(:subject){fixtures.author_photos.photo}
      it "should return an object that responds to proper methods" do
        subject.each do |photo|
          expected_methods.each do |method|
            photo.should respond_to(method)
          end
        end
      end
    end
  end

  describe "photo" do
    let(:subject){fixtures.photo}
    let(:expected_methods){fixtures.expected_methods.photo}

    it "should respond to :photo method" do
      fixtures.should respond_to(:photo)
    end

    it "should return an object that responds to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
  end

  describe "photo_details" do
    let(:subject){fixtures.photo_details}
    let(:expected_methods){fixtures.expected_methods.photo_details}

    it "should respond to :photo_details" do
      fixtures.should respond_to(:photo_details)
    end
    it "should return an object that responds to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
  end

  describe "photo_sizes" do
    let(:subject){fixtures.photo_sizes}
    let(:expected_methods){fixtures.expected_methods.photo_sizes}

    it "should respond to :photo_sizes method" do
      fixtures.should respond_to(:photo_sizes)
    end

    it "should return an object that respond to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end

    describe "size method" do
      let(:subject){fixtures.photo_sizes.size}
      let(:expected_methods){fixtures.expected_methods.photo_size}
      it "should yield objects that respond to proper methods" do
        subject.each do |size|
          expected_methods.each do |method|
            size.should respond_to(method)
          end
        end
      end
    end

  end

  describe "photo_size" do
    let(:subject){fixtures.photo_size}
    let(:expected_methods){fixtures.expected_methods.photo_size}

    it "should respond to photo_size method" do
      fixtures.should respond_to(:photo_size)
    end
    it "should respond to expected methods" do
      expected_methods.each do |method|
        subject.should respond_to(method)
      end
    end
  end
  
  describe "klass.repository" do
    it "should respond to a :repository class method" do
      klass.should respond_to(:repository)
    end
    it "should return a proper :repository" do
      expected = File.expand_path(File.dirname(__FILE__) + '/../fixtures') + '/'
      klass.repository.should eq(expected)
    end

  end

end






