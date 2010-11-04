require 'spec_helper'

describe APP::Api do
  let(:klass) {APP::Api}
  
  
  context "class methods" do
    specify {klass.should respond_to(:sanitize_tags)}
    context "sanitize_tags" do
      it "returns expected tags when specified" do
        klass.sanitize_tags('iran,shiraz').should == 'iran,shiraz'
      end
      it "returns lower cased version of tags when mixed case tag is specified" do
        klass.sanitize_tags('IrAn,ShiRaZ').should == 'iran,shiraz'
      end
      it "returns tags stripped of extraneous spaces between tags" do
        klass.sanitize_tags('iran ,        shiraz   ').should == 'iran,shiraz'
      end
      it "returns tags that preserve spaces within a tag" do
        klass.sanitize_tags('iran ,      shiraz hafez, isfehan').should == 'iran,shiraz hafez,isfehan'
      end
    end

    specify {klass.should respond_to(:sanitize_per_page)}
    context "sanitize_per_page" do
      it "returns expected per_page when per_page specified" do
        klass.sanitize_per_page(:per_page => '2').should == '2'
      end
      it "returns default per_page when per_page is not specified" do
        klass.sanitize_per_page({}).should == klass.default(:per_page)
      end
      it "returns expected per_page when perpage specified" do
        klass.sanitize_per_page(:perpage => '33').should == '33'
      end
      it "returns per_page when both :perpage and per_page is specified" do
        klass.sanitize_per_page(:per_page => '222', :perpage => '333').should == '222'
      end
    end

    specify {klass.should respond_to(:sanitize_page)}
    context "sanitize_page" do
      it "returns specified page number when given" do
        klass.sanitize_page(:page => 2).should == '2'
      end
      it "returns '1' when page number not specified" do
        klass.sanitize_page({}).should == '1'
      end
      it "returns '1' when string '0' specified for page number" do
        klass.sanitize_page(:page => '0').should == '1'
      end
      it "returns '1' when number 0 specified as page number" do
        klass.sanitize_page(:page => 0).should == '1'
      end
    end

    specify {klass.should respond_to(:sanitize_tag_mode)}
    context "sanitize_tag_mode" do
      it "returns 'any' if specified" do
        klass.sanitize_tag_mode(:tag_mode => 'any').should == 'any'
      end
      it "returns default tag_mode when non-specified" do
        klass.sanitize_tag_mode.should == klass.default(:tag_mode)
      end
      it "returns default tag_mode when garbage specified" do
        klass.sanitize_tag_mode(:tag_mode => 'garbage').should == klass.default(:tag_mode)
      end
      it "returns default tag mode if nil given" do
        klass.sanitize_tag_mode(:tag_mode => nil).should == klass.default(:tag_mode)
      end
      it "returns 'all' if specified" do
        klass.sanitize_tag_mode(:tag_mode => 'all').should == 'all'
      end
    end

    specify {klass.should respond_to(:sanitize_time)}
    context "sanitize_time" do
      it "returns expected date when format '2010-12-22'" do
        klass.sanitize_time(:date => '2010-12-22').should == '2010-12-22'
      end
      it "returns expected date when format 'Jan 1 2003'" do
        date = Chronic.parse('Jan 1 2003').strftime('%Y-%m-%d')
        klass.sanitize_time(:date => 'Jan 1 2003').should == date
      end
      it "returns yesterday if no date specified" do
        date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
        klass.sanitize_time.should == date
      end
    end
  end
end
