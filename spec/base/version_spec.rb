require 'spec_helper'

describe APP do
  subject{APP}
  context "constants" do
    context "VERSION" do
      it "returns non-empty version" do
        subject::VERSION.should_not be_empty
      end
    end
  end

  context "class methods" do
    context "version" do
      it "returns expected version" do
         subject.version.should == subject::VERSION
      end
    end
  end

end
