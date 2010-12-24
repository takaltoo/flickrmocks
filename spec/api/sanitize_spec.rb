require 'spec_helper'

describe APP::Api::Sanitize do
  let(:klass) {APP::Api::Sanitize}
  let(:api){APP::Api}
  
  context "class methods" do
    specify {klass.should respond_to(:tags)}
    context "tags" do
      it "returns nil when nil supplied" do
        klass.tags(nil).should == nil
      end
      context "specified as a string" do
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
      context "error conditions" do
        it "raises error when Array supplied" do
          expect {
            klass.tags([])
          }.to raise_error(ArgumentError)
        end
        it "raises error when Integer supplied" do
          expect {
            klass.tags(1)
          }.to raise_error(ArgumentError)
        end
      end
    end
    specify {klass.should respond_to(:tags_hash)}
    context ":tags_hash" do
      it "needs to be developed"
    end


    specify {klass.should respond_to(:per_page)}
    context "per_page" do
      it "returns default per_page when nil provided" do
        klass.per_page(nil).should == api.default(:per_page)
      end
      context "option as string" do
        it "returns value when string containing integer greater than 0" do
          klass.per_page('2').should == '2'
        end
        it "returns default per_page value when string is less than 1" do
          klass.per_page('-1').should == FlickrMocks::Api.default(:per_page)
        end
        it "returns default per_page value when string is '0'" do
          klass.per_page('0').should == FlickrMocks::Api.default(:per_page)
        end
      end
      context "option as integer" do
        it "returns value.to_s when option is greater than 0" do
          klass.per_page(2).should == '2'
        end
        it "returns default :per_page when option is 0" do
          klass.per_page(0).should == FlickrMocks::Api.default(:per_page)
        end
        it "returns default :per_page when option is negative" do
          klass.per_page(-1).should == FlickrMocks::Api.default(:per_page)
        end
      end
      context "error conditions" do
        it "raises an error when an array provided" do
          expect {
            klass.per_page([])
          }.to raise_error(ArgumentError)
        end
      end
    end
    specify {klass.should respond_to(:per_page_hash)}
    context ":per_page_hash" do
      it "needs to be developed"
    end

    # returns the page entry that is a positive non-zero integer
    specify {klass.should respond_to(:page)}
    context "page" do
      it "returns '1' when page number is nil" do
        klass.page(nil).should == '1'
      end
      context "integer argument" do
        it "returns default page when number is 0" do
          klass.page(0).should == FlickrMocks::Api.default(:page)
        end
        it "returns default page when number < 0" do
          klass.page(-1).should == FlickrMocks::Api.default(:page)
        end
        it "returns page when number > 0" do
          klass.page(20).should == '20'
        end
      end
      context "string argument" do
        it "returns specified page number when given" do
          klass.page(2).should == '2'
        end
        it "returns '1' when string '0' specified for page number" do
          klass.page('0').should == FlickrMocks::Api.default(:page)
        end
        it "returns '1' when number 0 specified as page number" do
          klass.page(0).should == FlickrMocks::Api.default(:page)
        end
      end
      context "error conditions" do
        it "raises error when Array specified" do
          expect {
            klass.page([])
          }.to raise_error(ArgumentError)
        end
      end
    end
    specify {klass.should respond_to(:page_hash)}
    context ":page_hash" do
      it "needs to be developed"
    end

    specify {klass.should respond_to(:tag_mode)}
    context "tag_mode" do
      it "returns default tag mode if nil given" do
        klass.tag_mode(nil).should == api.default(:tag_mode)
      end
      context "options specified as string" do
        it "returns 'any' if specified" do
          klass.tag_mode('any').should == 'any'
        end
        it "returns default tag_mode when non-specified" do
          klass.tag_mode.should == api.default(:tag_mode)
        end
        it "returns default tag_mode when garbage specified" do
          klass.tag_mode('garbage').should == api.default(:tag_mode)
        end
        it "returns 'all' if specified" do
          klass.tag_mode('all').should == 'all'
        end
      end
      context "error conditions" do
        it "raises error when array provided" do
          expect {
            klass.tag_mode([])
          }.to raise_error(ArgumentError)

        end
      end
    end

    specify {klass.should respond_to(:tag_mode_hash)}
    context ":tag_mode_hash" do
      it "needs to be developed"
    end

    specify {klass.should respond_to(:date)}
    context "date" do
      it "returns expected date when format '2010-12-22'" do
        klass.date('2010-12-22').should == '2010-12-22'
      end
      it "returns expected date when format 'Jan 1 2003'" do
        date = Chronic.parse('Jan 1 2003').strftime('%Y-%m-%d')
        klass.date('Jan 1 2003').should == date
      end
      it "returns yesterday if no date specified" do
        date = Chronic.parse('yesterday').strftime('%Y-%m-%d')
        klass.date.should == date
      end
    end

    specify {klass.should respond_to(:date_hash)}
    context ":date_hash" do
      it "needs to be developed"
    end
  end
end
