require 'spec_helper'

describe APP::Api do
  let(:api) {APP::Api::Options}
  let(:subject) {APP::Api::Options}
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
  

  context "search" do
    it "should give correct options when all options are specified except :author_id" do
      subject.search(options.clone.merge(:per_page =>'400')).should == expected
    end
    it "should return options when fully specified" do
      subject.search(:per_page => '400',:owner_id => 'authorid',:page => '2').should ==
        expected.clone.merge(:user_id => 'authorid',:tags => nil)
      
    end
    it "should give correct values when :perpage given in lieu of :per_page" do
      subject.search(options.clone.merge({:perpage => '400'})).should == expected
    end
    it "should give correct value when no :perpage is specified" do
      subject.search(options).should == expected.clone.merge({:per_page => '200'})
    end
    it "should give preference to :per_page to :perpage" do
      subject.search(options.clone.merge({:per_page => '500', :perpage => '444'})).should ==
        expected.clone.merge(:per_page => '500')
    end
    it "should be able to set :tag_mode" do
      subject.search(options.clone.merge(:per_page => '500', :tag_mode=>'all' )).should ==
        expected.clone.merge({:per_page => '500',:tag_mode => 'all'}
      )
    end
    it "should give default tag_mode when not specified" do
      subject.search(options.clone.merge(:per_page => '500')).should ==
        expected.clone.merge({:per_page => '500'}
      )
    end
    it "should give default tag_mode when junk given for tag_mode" do
      subject.search(options.clone.merge(:per_page => '500', :tag_mode => 'junk')).should ==
        expected.clone.merge({:per_page => '500'}
      )
    end
  end

  context "interesting" do
    let(:expected){
      { :date => '2010-02-14',
        :per_page => '2',
        :page => '2'
      }
    }
    it "should return proper date with default options" do
      subject.interesting(expected).should == expected.clone.merge(:extras => 'license')
    end
    it "should return proper date when no page given" do
      subject.interesting(:date => '2010-02-14', :per_page => '2').should ==
        expected.clone.merge(:page => '1', :extras => 'license')
    end
    it "should return proper date when not specified" do
      date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
      subject.interesting({:date => date})[:date].should == date
    end
  end

  context "photo" do
    let(:expected) {
      {:photo_id => '20030', :secret => 'abcdef'}
    }

    it "should extract :photo_id and :secret" do
      subject.photo(expected).should == expected
    end
    it "should return photo id when present" do
      subject.photo(:id => '20030',:secret => 'abcdef').should == expected
    end
    it "should give preference to :photo_id over :id" do
      subject.photo(expected.clone.merge(:id => 'not correct')).should == expected
    end
    it "should give preference to :photo_secret over :secret" do
      subject.photo(:photo_secret => 'abcdef', :secret => 'not correct', :id => '20030').should ==
        expected
      
    end
  end

  
end

 