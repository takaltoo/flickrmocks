require 'spec_helper'

describe APP::VERSION do
  subject{APP::VERSION}

  it "returns expected version number" do
    expected_version = File.read(File.expand_path("../../../VERSION", __FILE__)).strip
    subject.should == expected_version
  end

end
