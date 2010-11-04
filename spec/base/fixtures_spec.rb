require 'spec_helper'
require 'ruby-debug'

describe APP::Fixtures do

  let(:klass) {APP::Fixtures}
  let(:fixtures) {APP::Fixtures.new}
  let(:subject) {fixtures}
  
  context "class methods" do
    specify {klass.should respond_to(:repository)}
    context "repository" do
      it "returns expected directory for the repository" do
        expected = File.expand_path(File.dirname(__FILE__) + '/../fixtures') + '/'
        klass.repository.should == expected
      end
    end
  end


  context "instance_methods" do
    shared_examples_for "a flickraw fixture" do
      let (:subject) {fixtures.send(fixture)}
      let(:expected_methods){fixtures.expected_methods.send(fixture)}
      it "responds to expected methods" do
        expected_methods.each do |method|
          subject.should respond_to(method)
        end
      end
    end



    specify {subject.should respond_to(:photo)}
    context "photo" do
      let(:fixture) {:photo}
      it_behaves_like "a flickraw fixture"
    end
    
    specify {subject.should respond_to(:photos)}
    context "photos" do
      let(:fixture) {:photos}
      it_behaves_like "a flickraw fixture"
    end

    specify {subject.should respond_to(:empty_photos)}
    context "empty_photos" do
      let(:fixture){:empty_photos}
      it_behaves_like "a flickraw fixture"
    end
    
    specify {subject.should respond_to(:photo_details)}
    context "photo_details" do
      let(:fixture) {:photo_details}
      it_behaves_like "a flickraw fixture"
    end

    specify {subject.should respond_to(:interesting_photos)}
    context 'interesting_photos' do
      let(:fixture) {:interesting_photos}
      it_behaves_like "a flickraw fixture"
    end

    specify {subject.should respond_to(:author_photos)}
    context "author_photos" do
      let(:fixture) {:author_photos}
      it_behaves_like "a flickraw fixture"
    end

    specify {subject.should respond_to(:photo_size)}
    context "photo_size" do
      let(:fixture) {:photo_size}
      it_behaves_like "a flickraw fixture"
    end

    specify {subject.should respond_to(:photo_sizes)}
    context "photo_sizes" do
      let(:fixture) {:photo_sizes}
      it_behaves_like "a flickraw fixture"
    end
  end

end






