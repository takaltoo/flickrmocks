require 'spec_helper'

describe APP::VERSION do
  let(:klass){APP::VERSION}

  it "should provide the correct version" do
    expected_version = File.read(File.expand_path("../../../VERSION", __FILE__)).strip
    klass.should == expected_version
  end

end
