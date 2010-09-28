require 'spec_helper'

describe APP::Api do
  before(:each) do
    @api = APP::Api
    @extras = {
      :license => '4,5,6,7',
      :media => 'photos',
      :extras =>  'license',
      :tag_mode => 'any'
    }
    @expected = {
      :per_page => '400',
      :user_id => nil,
      :tags => 'iran,shiraz',
      :page => '2'}.merge(@extras.clone)
    @options = {
      :search_terms => 'iran,shiraz',
      :page => '2'
    }.merge(@extras.clone)
  end

  describe "search_options" do
    it "should give correct options when all options are specified except :author_id" do
      @api.search_options(@options.clone.merge(:per_page =>'400')).should == @expected
    end
    it "should return options when fully specified" do
      @api.search_options(:per_page => '400',:owner_id => 'authorid',:page => '2').should ==
        @expected.clone.merge(:user_id => 'authorid',:tags => nil)
    end
    it "should give correct values when :perpage given in lieu of :per_page" do
      @api.search_options(@options.clone.merge({:perpage => '400'})).should == @expected
    end
    it "should give correct value when no :perpage is specified" do
      @api.search_options(@options).should == @expected.clone.merge({:per_page => '200'})
    end
    it "should give preference to :per_page to :perpage" do
      @api.search_options(@options.clone.merge({:per_page => '500', :perpage => '444'})).should ==
        @expected.clone.merge(:per_page => '500')
    end
    it "should be able to set :tag_mode" do
      @api.search_options(@options.clone.merge(:per_page => '500', :tag_mode=>'all' )).should ==
        @expected.clone.merge({:per_page => '500',:tag_mode => 'all'})
    end
    it "should give default tag_mode when not specified" do
      @api.search_options(@options.clone.merge(:per_page => '500')).should ==
        @expected.clone.merge({:per_page => '500'})
    end
    it "should give default tag_mode when junk given for tag_mode" do
      @api.search_options(@options.clone.merge(:per_page => '500', :tag_mode => 'junk')).should ==
        @expected.clone.merge({:per_page => '500'})
    end
  end

  describe "interesting_options" do
    before(:each) do
      @expected = {
        :date => '2010-02-14',
        :per_page => '2',
        :page => '2'
      }
    end

    it "should return proper date with default options" do
      @api.interesting_options(@expected).should == @expected.clone.merge(:extras => 'license')
    end
    it "should return proper date when no page given" do
      @api.interesting_options(:date => '2010-02-14', :per_page => '2').should ==
        @expected.clone.merge(:page => '1', :extras => 'license')
    end
    it "should return proper date when not specified" do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      @api.interesting_options({:date => date})[:date].should == date
    end
  end

  describe "photo_options" do
    before(:each) do
      @expected = {:photo_id => '20030', :secret => 'abcdef'}
    end
    it "should extract :photo_id and :secret" do
      @api.photo_options(@expected).should == @expected
    end
    it "should return photo id when present" do
      @api.photo_options(:id => '20030',:secret => 'abcdef').should == @expected
    end
    it "should give preference to :photo_id over :id" do
      @api.photo_options(@expected.clone.merge(:id => 'not correct')).should == @expected
    end
    it "should give preference to :photo_secret over :secret" do
      @api.photo_options(:photo_secret => 'abcdef', :secret => 'not correct', :id => '20030').should ==
        @expected
    end
  end

  describe "search_params" do
    before(:each) do
      @expected = {
        :search_terms => 'iran,shiraz',
        :owner_id => 'authorid',
        :base_url => 'http://www.happyboy.com/'
      }
    end
    it "should return properly when all options specified" do
      @api.search_params(@expected).should == @expected
    end
    it "should filter non-required options" do
      @api.search_params(@expected.clone.merge(:date => '2010-10-02',:per_page => '2')).should ==
        @expected
    end
    it "should properly extract :base_url" do
      @api.search_params(@expected.clone.merge(:base_url =>'http://www.example.com/')).should ==
        @expected.clone.merge(:base_url => 'http://www.example.com/')
    end
  end

  describe "interesting_params" do
    before(:each) do
      @expected = {
        :date => 'iran,shiraz',
        :base_url => 'http://www.happyboy.com/'
      }
    end
    it "should return correct options when all are specified" do
      @api.interesting_params(@expected).should == @expected
    end
    it "should filter non-required options" do
      @api.interesting_params(@expected.clone.merge(:search_terms => 'iran,shiraz',
          :owner_id => 'authorid')).should == @expected
    end
    it "should extract base_url options" do
      @api.interesting_params(@expected.clone.merge(:base_url => 'http://www.example.com/')).should ==
        @expected.clone.merge(:base_url => 'http://www.example.com/')
    end
  end

end

 