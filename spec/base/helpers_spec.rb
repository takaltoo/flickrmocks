require 'spec_helper'

describe APP::Helpers do
  let(:klass) {APP::Helpers}
  let(:fixtures) {APP::Fixtures.new}

  context "class methods" do

    specify {klass.should respond_to(:extension)}
    context 'extension' do
      it "returns expected extension: .marshal" do
        klass.extension.should == '.marshal'
      end
    end

    specify {klass.should respond_to(:fname_fixture)}
    context "fname_fixture" do
      it "returns correct fixture file name with symbol argument" do
        expected_fname = 'sample_file' + klass.extension
        klass.fname_fixture(:sample_file).should == expected_fname
      end
      it "raises an error when file name is a string" do
        expect {klass.fname_fixture('sample_file')}.to raise_error
      end
    end

    specify {klass.should respond_to(:equivalent?)}
    context "equivalent?" do
      it "returns true when photo_detail object compared to itself" do
        klass.should be_equivalent(fixtures.photo_details,fixtures.photo_details)
      end
      it "returns true when photo_sizes object is compared to itself" do
        klass.should be_equivalent(fixtures.photo_sizes,fixtures.photo_sizes)
      end
      it "returns true when same photo object is compared to itself" do
        klass.should be_equivalent(fixtures.photos,fixtures.photos)
      end
      it "returns false when photo_details object is compared to photo object" do
        klass.should_not be_equivalent(fixtures.photo_details, fixtures.photos.first)
      end
      it "returns false when photo_sizes object is compared to photo_details object" do
        klass.should_not be_equivalent(fixtures.photo_sizes,fixtures.photo_details)
      end
    end

    specify {klass.should respond_to(:dump)}
    specify {klass.should respond_to(:load)}
    context "dump/load behavior" do
      it "dumps and loads an object without losing data" do
        begin
          fname = "/tmp/#{Time.now}_#{Random.rand}"
          expected = [Random.rand,Random.rand]
          klass.dump(expected,fname)
          actual = klass.load(fname)
          actual.should == expected
        ensure
          File.delete fname
        end
      end
    end

  end
end