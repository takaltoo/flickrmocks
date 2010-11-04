require 'spec_helper'

describe APP::Api do
  
  let(:klass) {APP::Api}  
  context "class methods" do
    specify {klass.should respond_to(:default)}
    context "default" do
      it "returns key stored in @defaults class instance variable when symbol specified" do
        klass.default(:per_page).should == klass.defaults[:per_page]
      end
      it "returns key stored in @defaults class instance variable when string specified" do
        klass.default('per_page').should  == klass.defaults[:per_page]
      end
      it "returns nil when key that is not in @defaults class instance variable is specified" do
        klass.default('garbage').should == nil
      end
    end

    specify {klass.should respond_to(:time)}
    context "time" do
      it "returns yesterday when no time is specified" do
        expected = Chronic.parse('yesterday').strftime('%Y-%m-%d')
        klass.time.should == expected
      end

      it "returns user specified date when proper date given" do
        expected = '2010-12-25'
        klass.time(expected).should == expected
      end

      it "returns yesterday when garbage date given" do
        klass.time('garbage').should == Chronic.parse('yesterday').strftime('%Y-%m-%d')
      end
    end
  end
end
