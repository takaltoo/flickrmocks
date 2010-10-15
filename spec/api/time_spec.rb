require 'spec_helper'

describe APP::Api do

  let(:api) {APP::Api}

  it "should give correct time if not specified" do
    expected = Chronic.parse('yesterday').strftime('%Y-%m-%d')
    api.time.should == expected
  end
  
  it "should use specified date when given" do
    expected = '2010-12-25'
    api.time(expected).should == expected
  end
end
