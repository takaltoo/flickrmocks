require 'spec_helper'
require 'ruby-debug'

describe APP::Fixtures do

  let(:klass) {APP::Fixtures}
  let(:fixtures) {APP::Fixtures.new}


  describe "expected fixtures present" do
    shared_examples_for "any flickraw fixture" do
      let(:subject) {fixtures.send(fixture)}
      let(:expected_methods){fixtures.expected_methods.send(fixture)}

      it "should respond to method" do
        fixtures.should respond_to(fixture)
      end
      it "should respond to expected methods" do
        expected_methods.each do |method|
          subject.should respond_to(method)
        end
      end
    end

    context "photos" do
      let(:fixture) {:photos}
      it_behaves_like "any flickraw fixture"
    end

    context 'interesting_photos' do
      let(:fixture) {:interesting_photos}
      it_behaves_like "any flickraw fixture"
    end

    context "author_photos" do
      let(:fixture) {:author_photos}
      it_behaves_like "any flickraw fixture"
    end

    context "photo" do
      let(:fixture) {:photo}
      it_behaves_like "any flickraw fixture"
    end

    context "photo_details" do
      let(:fixture) {:photo_details}
      it_behaves_like "any flickraw fixture"
    end

    context "photo_sizes" do
      let(:fixture) {:photo_sizes}
      it_behaves_like "any flickraw fixture"
    end

    context "photo_size" do
      let(:fixture) {:photo_size}
      it_behaves_like "any flickraw fixture"
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






