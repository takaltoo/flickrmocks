require 'spec_helper'

describe APP::Api do
  let(:api) {APP::Api}
  let(:subject) {api}
  let(:extras){
    { :license => '4,5,6,7',
      :media => 'photos',
      :extras =>  'license',
      :tag_mode => 'any'}
  }
  let(:expected){
    { :per_page => '400',
      :user_id => nil,
      :tags => 'iran,shiraz',
      :page => '2'}.merge(extras.clone)
  }

  let(:options){
    {
      :search_terms => 'iran,shiraz',
      :page => '2'
    }.merge(extras.clone)
  }
  

  describe "search_options" do
    it "should give correct options when all options are specified except :author_id" do
      subject.search_options(options.clone.merge(:per_page =>'400')).should eq(expected)
    end
    it "should return options when fully specified" do
      subject.search_options(:per_page => '400',:owner_id => 'authorid',:page => '2').should eq(
        expected.clone.merge(:user_id => 'authorid',:tags => nil)
      )
    end
    it "should give correct values when :perpage given in lieu of :per_page" do
      subject.search_options(options.clone.merge({:perpage => '400'})).should eq(expected)
    end
    it "should give correct value when no :perpage is specified" do
      subject.search_options(options).should eq(expected.clone.merge({:per_page => '200'}))
    end
    it "should give preference to :per_page to :perpage" do
      subject.search_options(options.clone.merge({:per_page => '500', :perpage => '444'})).should eq(
        expected.clone.merge(:per_page => '500'))
    end
    it "should be able to set :tag_mode" do
      subject.search_options(options.clone.merge(:per_page => '500', :tag_mode=>'all' )).should eq(
        expected.clone.merge({:per_page => '500',:tag_mode => 'all'})
      )
    end
    it "should give default tag_mode when not specified" do
      subject.search_options(options.clone.merge(:per_page => '500')).should eq(
        expected.clone.merge({:per_page => '500'})
      )
    end
    it "should give default tag_mode when junk given for tag_mode" do
      subject.search_options(options.clone.merge(:per_page => '500', :tag_mode => 'junk')).should eq(
        expected.clone.merge({:per_page => '500'})
      )
    end
  end

  describe "interesting_options" do
    let(:expected){
      { :date => '2010-02-14',
        :per_page => '2',
        :page => '2'
      }
    }
    it "should return proper date with default options" do
      subject.interesting_options(expected).should eq(expected.clone.merge(:extras => 'license'))
    end
    it "should return proper date when no page given" do
      subject.interesting_options(:date => '2010-02-14', :per_page => '2').should eq(
        expected.clone.merge(:page => '1', :extras => 'license')
      )
    end
    it "should return proper date when not specified" do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      subject.interesting_options({:date => date})[:date].should eq(date)
    end
  end

  describe "photo_options" do
    let(:expected) {
      {:photo_id => '20030', :secret => 'abcdef'}
    }

    it "should extract :photo_id and :secret" do
      subject.photo_options(expected).should eq(expected)
    end
    it "should return photo id when present" do
      subject.photo_options(:id => '20030',:secret => 'abcdef').should eq(expected)
    end
    it "should give preference to :photo_id over :id" do
      subject.photo_options(expected.clone.merge(:id => 'not correct')).should eq(expected)
    end
    it "should give preference to :photo_secret over :secret" do
      subject.photo_options(:photo_secret => 'abcdef', :secret => 'not correct', :id => '20030').should eq(
        expected
      )
    end
  end

  describe "search_params" do
    let(:expected){
      {
        :search_terms => 'iran,shiraz',
        :owner_id => 'authorid',
        :base_url => 'http://www.happyboy.com/'
      }
    }
    let(:base_url) {'http://www.example.com/'}
    
    it "should return properly when all options specified" do
      subject.search_params(expected).should eq(expected)
    end
    it "should filter non-required options" do
      subject.search_params(expected.clone.merge(:date => '2010-10-02',:per_page => '2')).should eq(
        expected
      )
    end
    it "should properly extract :base_url" do
      subject.search_params(expected.clone.merge(:base_url => base_url)).should eq(
        expected.clone.merge(:base_url => base_url)
      )
    end
  end

  describe "interesting_params" do
    
    let(:expected) {
      {
        :date => 'iran,shiraz',
        :base_url => 'http://www.happyboy.com/'
      }
    }
    it "should return correct options when all are specified" do
      subject.interesting_params(expected).should eq(expected)
    end
    it "should filter non-required options" do
      subject.interesting_params(expected.clone.merge(:search_terms => 'iran,shiraz',
          :owner_id => 'authorid')).should eq(expected)
    end
    it "should extract base_url options" do
      subject.interesting_params(expected.clone.merge(:base_url => expected[:base_url])).should ==
        expected.clone.merge(:base_url => expected[:base_url])
    end
  end
  
end

 