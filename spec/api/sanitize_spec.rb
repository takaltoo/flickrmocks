require 'spec_helper'

describe APP::Api do
  let(:api) {APP::Api}
  let(:subject){api}

  describe "sanitize_tags" do
    it "should return proper tags with baseline options" do
      subject.sanitize_tags('iran,shiraz').should == 'iran,shiraz'
    end
    it "should convert tags to lower case" do
      subject.sanitize_tags('IrAn,ShiRaZ').should == 'iran,shiraz'
    end
    it "should properly remove spaces from tags" do
      subject.sanitize_tags('iran ,        shiraz   ').should == 'iran,shiraz'
    end
    it "should properly preserve spaces within a tag" do
      subject.sanitize_tags('iran ,      shiraz hafez, isfehan').should == 'iran,shiraz hafez,isfehan'
    end
  end

  describe "sanitize_tags" do
    it "should return proper :per_page" do
      subject.sanitize_per_page(:per_page => '2').should == '2'
    end
    it "should default per_page if it were specified" do
      subject.sanitize_per_page({}).should == subject.default(:per_page)
    end
    it "should extract :per_page over :perpage" do
      subject.sanitize_per_page(:per_page => '222', :perpage => '333').should == '222'
    end
  end

  describe "sanitize_page" do
    it "should return proper page number" do
      subject.sanitize_page(:page => 2).should == '2'
    end
    it "should not give correct page if unspecified" do
      subject.sanitize_page({}).should == '1'
    end
    it "should give page 1 if '0' given" do
      subject.sanitize_page(:page => '0').should == '1'
    end
    it "should give correct page if 0 given" do
      subject.sanitize_page(:page => 0).should == '1'
    end
  end

  describe "sanitize_tag_mode" do
    it "should return default tag_mode if none given" do
      subject.sanitize_tag_mode.should == subject.default(:tag_mode)
    end
    it "should return default tag mode if junk tag_mode specified" do
      subject.sanitize_tag_mode(:tag_mode => 'junk').should == subject.default(:tag_mode)
    end
    it "should return default tag mode if nil given" do
      subject.sanitize_tag_mode(:tag_mode => nil).should == subject.default(:tag_mode)
    end
    it "should return 'all' if specified" do
      subject.sanitize_tag_mode(:tag_mode => 'all').should == 'all'
    end
  end

  describe "sanitize_time" do
    it "should return correct time when specified" do
      subject.sanitize_time(:date => '2010-12-22').should == '2010-12-22'
    end
    it "should give corect date if specified" do
      date = Chronic.parse('Jan 1 2003').strftime('%Y-%m-%d')
      subject.sanitize_time(:date => 'Jan 1 2003').should == date
    end
    it "should default to yesterday of no date specified" do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      subject.sanitize_time.should == date
    end
  end
end
  