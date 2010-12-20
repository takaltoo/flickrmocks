require 'spec_helper'

describe APP::VERSION do
  subject{APP::VERSION}

  context "constants" do
    context "VERSION" do
      it "returns non-empty version" do
        subject.should_not be_empty
      end
    end
  end

end
