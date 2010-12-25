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
  
  specify {subject.should respond_to(:search)}
  context "search" do
    let(:method){:search}
    it "should give correct options when all options are specified except :author_id" do
      subject.search(options.clone.merge(:per_page =>'400')).should == expected
    end
    it "should return options when fully specified" do
      subject.search(:per_page => '400',:owner_id => 'authorid',:page => '2').should ==
        expected.clone.merge(:user_id => 'authorid',:tags => nil)
      
    end
    context "tag_mode option" do
      let(:options){
        extras.clone.merge({
            :search_terms => 'france',
            :owner_id =>  '1234',
            :page =>  '1',
            :per_page => '50'
          })
      }
      let(:expected){
        extras.clone.merge({
            :tags => options[:search_terms],
            :user_id =>  options[:owner_id],
            :page =>  options[:page],
            :per_page => options[:per_page]
          })
      }
      it_behaves_like "tag mode hash option"
    end
    context "per page option" do
      let(:options){
        extras.clone.merge({
            :search_terms => 'france',
            :owner_id =>  '1234',
            :page =>  '1',
          })
      }
      let(:expected){
        extras.clone.merge({
            :tags => options[:search_terms],
            :user_id =>  options[:owner_id],
            :page =>  options[:page],
          })
      }
      it_behaves_like "per page hash option"
    end
    context "page option" do
      let(:options){
        extras.clone.merge({
            :search_terms => 'france',
            :owner_id =>  '1234',
            :per_page =>  '50',
          })
      }
      let(:expected){
        extras.clone.merge({
            :tags => options[:search_terms],
            :user_id =>  options[:owner_id],
            :per_page =>  options[:per_page],
          })
      }
      it_behaves_like "page hash option"      
    end
  end

  specify {subject.should respond_to(:interesting)}
  context "interesting" do
    let(:method){:interesting}
    context "date option" do
      let(:options){{
          :per_page => '2',
          :page => '2',
          :extras => 'license'
        }}
      let(:expected){options}
      it_behaves_like "date hash option"
    end
    
    context "page option" do
      let(:options){
        {   :date => '2010-10-10',
          :per_page =>  '50',
          :extras => FlickrMocks::Api.default(:extras)
        }}
      let(:expected){options}
      it_behaves_like "page hash option"
    end
    context "per page option" do
      let(:options){
        { :date => '2010-10-10',
          :page =>  '1',
          :extras => FlickrMocks::Api.default(:extras)
        }}
      let(:expected){options}
      it_behaves_like "per page hash option"
    end
  end

  specify{subject.should respond_to(:photo)}
  context "photo" do
    let(:expected) {
      {:photo_id => '20030', :secret => 'abcdef'}
    }
    it "returns :photo_id and :secret when provided" do
      subject.photo(expected).should == expected
    end
    it "returns :photo_id when :id provided" do
      subject.photo(:id => '20030',:secret => 'abcdef').should == expected
    end
    it "should prefer :photo_id over :id" do
      subject.photo(expected.clone.merge(:id => 'not correct')).should == expected
    end
    it "should prefer :photo_secret over :secret" do
      subject.photo(:photo_secret => 'abcdef', :secret => 'not correct', :id => '20030').should ==
        expected   
    end
    it "returns nil for :photo_id when no id given" do
      subject.photo({:secret => '22'}).should ==
        {:secret => '22', :photo_id => nil}
    end
    it "returns nil for :secret when no :secret given" do
      subject.photo({:photo_id => '1234'}).should ==
        {:secret => nil, :photo_id => '1234'}
    end
    it "returns nil for :secret and :photo_id when nil provided" do
      subject.photo({:photo_id => nil, :secret => nil}).should ==
        {:secret => nil, :photo_id => nil}
    end
  end



  specify {subject.should respond_to(:author)}
  context "author" do
    let(:method){:author}
    let(:expected){
      { :per_page => '400',
        :user_id => nil,
        :page => '2'}.merge(extras.clone)
    }
    it "should give correct options when all options are specified except :author_id" do
      subject.author(options.clone.merge(:per_page =>'400')).should == expected
    end
    it "should return options when fully specified" do
      subject.author(:per_page => '400',:owner_id => 'authorid',:page => '2').should ==
        expected.clone.merge(:user_id => 'authorid')

    end
    context "tag_mode option" do
      it "should be able to set :tag_mode" do
        subject.author(options.clone.merge(:per_page => '500', :tag_mode=>'all' )).should ==
          expected.clone.merge({:per_page => '500',:tag_mode => 'all'}
        )
      end
      it "should give default tag_mode when not specified" do
        subject.author(options.clone.merge(:per_page => '500')).should ==
          expected.clone.merge({:per_page => '500'}
        )
      end
      it "should give default tag_mode when junk given for tag_mode" do
        subject.author(options.clone.merge(:per_page => '500', :tag_mode => 'junk')).should ==
          expected.clone.merge({:per_page => '500'}
        )
      end
    end
    context "per page option" do
      let(:options){
        extras.clone.merge({
            :search_terms => 'france',
            :owner_id =>  '1234',
            :page =>  '1',
          })
      }
      let(:expected){
        extras.clone.merge({
            :user_id =>  options[:owner_id],
            :page =>  options[:page],
          })
      }
      it_behaves_like "per page hash option"
    end
    context "page option" do
      let(:options){
        extras.clone.merge({
            :search_terms => 'france',
            :owner_id =>  '1234',
            :per_page =>  '50',
          })
      }
      let(:expected){
        extras.clone.merge({
            :user_id =>  options[:owner_id],
            :per_page =>  options[:per_page],
          })
      }
      it_behaves_like "page hash option"
    end
  end
end

 