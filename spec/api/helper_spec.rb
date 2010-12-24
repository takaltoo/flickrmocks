require 'spec_helper'

describe APP::Api::Helpers do
  
  let(:klass) {APP::Api::Helpers}
  context "class methods" do
    specify {klass.should respond_to(:date)}
    context "date" do
      it "returns yesterday when no time is specified" do
        expected = Chronic.parse('yesterday').strftime('%Y-%m-%d')
        klass.date.should == expected
      end

      it "returns user specified date when proper date given" do
        expected = '2010-12-25'
        klass.date(expected).should == expected
      end

      it "returns yesterday when garbage date given" do
        klass.date('garbage').should == Chronic.parse('yesterday').strftime('%Y-%m-%d')
      end
    end
  end

  specify {klass.should respond_to(:valid_date?)}
  context "valid_date?" do
    it "returns true when valid string of Format 'YYYY-MM-DD' provided" do
      klass.valid_date?('2001-10-10').should be_true
    end
  end
end
