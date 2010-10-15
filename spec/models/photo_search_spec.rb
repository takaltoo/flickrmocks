require 'spec_helper'

describe APP::PhotoSearch do
  let(:api) {APP::Api}
  let(:klass) {APP::PhotoSearch}

  let(:fixtures){APP::Fixtures.new}
  let(:photos_fixture) {fixtures.photos}
  let(:options) {{:search_terms => 'iran', :page => '20', :date => '2010-10-03'}}
  let(:subject) {klass.new fixtures.photos,options}
  


  describe "self.defaults accessor method" do
    it "should respond to defaults" do
      klass.should respond_to(:defaults)
    end
    describe "set/get default values" do
      before(:each) do
        @defaults = klass.defaults.clone
      end
      after(:each) do
        klass.defaults = @defaults
      end
      it "should be able to get/set variables" do
        klass.defaults.keys do |key|
          value = klass.send[key]
          expected = value*2
          klass[key] = expected
          klass[key].should == expected
        end
      end
    end
  end

  describe "initialization" do
    describe "photo option" do
      describe "providing FlickRaw::ResponseList" do
        it "should not raise error" do
          lambda { klass.new(photos_fixture)}.should_not raise_error
        end
        it ":photos method should return Photos class" do
          klass.new(photos_fixture).photos.should be_an_instance_of(APP::Photos)
        end
      end

      describe "providing APP::Photos object" do
        it "should not raise error" do
          lambda { klass.new(APP::Photos.new(photos_fixture)).should_not raise_error}
        end
        it ":photos methods should return Photos class" do
          klass.new(APP::Photos.new(photos_fixture)).photos.should be_an_instance_of(APP::Photos)
        end
      end

      describe "unexpected object types" do
        it "should raise error when no object provided" do
          lambda {klass.new}.should raise_error
        end
        it "shoud raise error on Array" do
          lambda {klass.new([1,2,3,4])}.should raise_error
        end
        it "should raise error on Hash" do
          lambda {klass.new({:hello => 'hello', :goodbye => 'goodbye'})}.should raise_error
        end
      end
    end

    describe "options hash" do
      describe "successful" do
        let(:options){{:search_terms => 'shiraz,iran',:page => 1,:date => '2010-09-10'}}
        it "should not raise an error when all options specified" do
          lambda {klass.new(photos_fixture,options)}.should_not raise_error
        end
        describe 'nil date' do
          let(:options){{:search_terms => 'shiraz,iran',:page => 1,:date => nil}}
          it "should not raise an error when date is nil" do
            lambda {klass.new(photos_fixture,options)}.should_not raise_error
          end
        end
      end
      describe "failure" do
        it "should raise an error when date is given as integer" do
          lambda {klass.new(photos_fixture,{:date => 222})}.should raise_error
        end
        it "should raise an error when date supplied that can not be parsed by Chronic" do
          lambda {klass.new(photos_fixture,{:date => '2010'})}.should raise_error
        end
        it "should raise an error when search terms is an integer" do
          lambda {klass.new(photos_fixture,{:search_terms => 22})}.should raise_error
        end
      end
    end
  end

  describe "search_terms" do
    let(:search_terms){'shiraz,iran'}
    let(:subject) {klass.new(photos_fixture,{:search_terms => search_terms})}

    it "should return proper search terms" do
      subject.search_terms.should == search_terms
    end
    describe "empty search terms" do
      let(:subject){ klass.new(photos_fixture,{}).search_terms}
      it "should return empty string when nil search terms provided" do
        subject.should == ""
      end
    end
  end

  describe "page" do
    let(:page) {20}
    let(:subject) {klass.new(photos_fixture,{:page => page})}
    it "should return proper page" do
      subject.page.should == page
    end
    describe "empty page" do
      let(:subject) {klass.new(photos_fixture,{})}
      it "should return 1 if no page specified" do
        subject.page.should == 1
      end
    end
  end

  describe "date" do
    let(:date) {'2010-09-10'}
    let(:subject) {klass.new(photos_fixture,{:date => date})}

    it "should return proper date" do
      subject.date.should == date
    end
    describe "empty date" do
      let(:subject) {klass.new(photos_fixture,{})}
      it "should set date to be yesterday" do
        subject.date.should be_nil  
      end
    end
  end

  describe ":[]" do
    it "should respond to :[]" do
      subject.should respond_to(:[])
    end
    it "should be able to iterate through all items" do
      index = 0
      subject.photos.each do |photo|
        subject[index].should == photo
        index+=1
      end
    end
  end

  describe "first" do
    it "should respond to the first method" do
      subject.should respond_to(:first)
    end
    it "should give proper first item" do
      subject.first.should == subject.photos[0]
    end
  end

  describe "last" do
    it "should respond to last method" do
      subject.should respond_to(:last)
    end
    it "should give proper last item" do
      subject.last.should == subject.photos[-1]
    end
  end

  describe ":each" do
    it "should respond to :each method" do
      subject.should respond_to(:each)
    end
    it "should yield appropriate object" do
      index = 0
      subject.each do |photo|
        photo.should == subject.photos[index]
        index+=1
      end
    end
  end


  describe "metaprogramming methods" do
    describe "delegated_methods" do
      it "should not be empty" do
        subject.delegated_methods.should_not be_empty
      end
      it "should return correct value" do
        subject.delegated_methods.reject do |v| v==:photos end.each do |method|
          subject.send(method).should  == subject.photos.send(method)
        end
      end
    end

    describe "methods" do
      it "should be more methods than delegated_methods" do
        subject.methods.length.should > subject.delegated_methods.length
      end
      it "should contain delegated methods" do
        (subject.delegated_methods - subject.methods).should be_empty
      end
    end

    describe "respond_to?" do
      it "should return true for all delegated methods" do
        subject.delegated_methods.each do |method|
          subject.should respond_to(method)
        end
      end
      it "should return true for all methods" do
        subject.methods.each do |method|
          subject.should respond_to(method)
        end
      end
    end
  end

  describe "url_params" do
    describe "no page given"
    it "should return proper search params when all options specified" do
      options = {:page => 20, :date => '2010-12-20', :search_terms => 'iran,shiraz'}
      klass.new(photos_fixture,options).url_params.should == options
    end
    it "should not return :date if empty" do
      options = {:page => 20, :date => nil, :search_terms => 'iran,shiraz'}
      klass.new(photos_fixture,options).url_params.should == {:page => 20, :search_terms => 'iran,shiraz'}
    end
    it "should return page=1 if page is empty" do
      options = {:page => nil, :date => '2010-12-20', :search_terms => 'iran,shiraz'}
      klass.new(photos_fixture,options).url_params.should == {:date => '2010-12-20',
        :search_terms => 'iran,shiraz',
        :page=>1}
    end
    it "should return yesterday for date if date is empty and search_terms is empty" do
      options = {:page => 2, :date => nil, :search_terms => nil}
      klass.new(photos_fixture,options).url_params.should == {:date => APP::Api.time, :page => 2}
    end
  end

  describe "page given" do
    it "should take passed in page" do
      options = {:page => 20, :date => '2010-12-20', :search_terms => 'iran,shiraz'}
      klass.new(photos_fixture,options).url_params(:page => 3).should == options.clone.merge(:page => 3)
    end
  end

  describe "url_params_string" do
    it "should return proper search params when all options specified" do
      options = {:page => 20, :date => '2010-12-20', :search_terms => 'iran,shiraz'}
      klass.new(photos_fixture,options).url_params_string(options).should == 'date=2010-12-20&page=20&search_terms=iran%2Cshiraz'
    end
  end

  describe "clone" do
    it "should have photos that are independent of itself" do
      other = subject.clone
      index = -1
      subject.photos.each do |photo|
        index +=1
        photo.__id__.should_not == other.photos[index].__id__
      end
    end
  end

  describe "==" do
    it "should be equal to itself" do
      subject.should == subject
    end
    it "should be equal to clone of itself" do
      subject.should == subject.clone
    end
    it "should not equal when one element of photo is different" do
      other = subject.clone
      other.photos.last.instance_eval('@__delegated_to_object__').instance_eval('@h["server"]="1234321"')
      subject.should_not == other
      subject.photos.last.instance_eval('@__delegated_to_object__').instance_eval('@h["server"]="1234321"')
      subject.should == other
    end
  end


end



