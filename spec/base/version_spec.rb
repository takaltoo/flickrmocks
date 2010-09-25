require 'spec_helper'

describe APP::VERSION do
  it "should provide the correct version" do
    expected_version = File.read(File.expand_path("../../../VERSION", __FILE__)).strip
    APP::VERSION.should == expected_version
  end
end
