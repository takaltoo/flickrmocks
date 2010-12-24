require 'spec_helper'

describe APP::Api::Sanitize do
  let(:klass) {APP::Api::Sanitize}
  let(:api){APP::Api}
  
  
  context "class methods" do
    specify {klass.should respond_to(:tags)}
    context "tags" do
      it "returns expected tags when specified" do
        klass.tags('iran,shiraz').should == 'iran,shiraz'
      end
      it "returns lower cased version of tags when mixed case tag is specified" do
        klass.tags('IrAn,ShiRaZ').should == 'iran,shiraz'
      end
      it "returns tags stripped of extraneous spaces between tags" do
        klass.tags('iran ,        shiraz   ').should == 'iran,shiraz'
      end
      it "returns tags that preserve spaces within a tag" do
        klass.tags('iran ,      shiraz hafez, isfehan').should == 'iran,shiraz hafez,isfehan'
      end
    end

    specify {klass.should respond_to(:per_page)}
    context "per_page" do
      it "returns value when string containing integer greater than 0" do
        klass.per_page('2').should == '2'
      end
      it "returns default per_page when no value provided" do
        klass.per_page(nil).should == api.default(:per_page)
      end
    end

    specify {klass.should respond_to(:page)}
    context "page" do
      it "returns specified page number when given" do
        klass.page(2).should == '2'
      end
      it "returns '1' when page number not specified" do
        klass.page(nil).should == '1'
      end
      it "returns '1' when string '0' specified for page number" do
        klass.page('0').should == '1'
      end
      it "returns '1' when number 0 specified as page number" do
        klass.page(0).should == '1'
      end
    end

    specify {klass.should respond_to(:tag_mode)}
    context "tag_mode" do
      it "returns 'any' if specified" do
        klass.tag_mode('any').should == 'any'
      end
      it "returns default tag_mode when non-specified" do
        klass.tag_mode.should == api.default(:tag_mode)
      end
      it "returns default tag_mode when garbage specified" do
        klass.tag_mode('garbage').should == api.default(:tag_mode)
      end
      it "returns default tag mode if nil given" do
        klass.tag_mode(nil).should == api.default(:tag_mode)
      end
      it "returns 'all' if specified" do
        klass.tag_mode('all').should == 'all'
      end
    end

    specify {klass.should respond_to(:date)}
    context "date" do
      it "returns expected date when format '2010-12-22'" do
        klass.date(:date => '2010-12-22').should == '2010-12-22'
      end
      it "returns expected date when format 'Jan 1 2003'" do
        date = Chronic.parse('Jan 1 2003').strftime('%Y-%m-%d')
        klass.date(:date => 'Jan 1 2003').should == date
      end
      it "returns yesterday if no date specified" do
        date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
        klass.date.should == date
      end
    end
  end
end
