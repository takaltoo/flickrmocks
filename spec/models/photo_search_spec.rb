require 'spec_helper'

describe APP::Models::PhotoSearch do
  let(:api) {APP::Api}
  let(:models){APP::Models}
  let(:klass) {models::PhotoSearch}
  let(:fixtures){APP::Fixtures.instance}
  let(:options) {{:search_terms => 'iran', :page => '20', :date => '2010-10-03'}}

  subject { klass.new fixtures.photos,options }

  context "class instance variables" do
    specify {klass.should respond_to(:defaults)}
    context "defaults" do
      it "returns expected set of defaults" do
        klass.defaults.should == {:page => 1}
      end
    end

    specify {klass.should respond_to(:delegated_instance_methods)}
    it "returns expected set of methods" do
      klass.delegated_instance_methods.sort.should == [:current_page, :per_page,
        :total_entries,:perpage, :capped?, :max_entries, :collection,:capped_entries].sort
    end
  end

  context "initialization" do
    context "photos argument" do
      let(:options){{:search_terms => 'shiraz,iran',:page => 1,:date => '2010-09-10'}}
      it "returns object of proper class when photos responselist object specified" do
        klass.new(fixtures.photos, options).class.should == klass
      end
      it "returns object of proper class when Photos object is provided" do
        klass.new(models::Photos.new(fixtures.photos),options).class.should == klass
      end
      it "raises an error when an array is provided" do
        expect {
          klass.new([],options)
        }.to raise_error(ArgumentError)
      end
      it "raises an error when photo response object specified" do
        expect {
          klass.new(fixtures.photo,options)
        }.to raise_error(ArgumentError)
      end

    end

    context "options hash argument" do
      it "returns object of proper class when all options specified" do
        klass.new(fixtures.photos,{:search_terms => 'shiraz,iran',
            :page => 1,:date => '2010-09-10'}).class.should == klass
      end
      it "returns object of proper class when date is nil" do
        klass.new(fixtures.photos,{:search_terms => 'shiraz,iran',:page => 1,:date => nil}).class.should == klass
      end
      it "raises an error when date is a Fixnum" do
        expect {
          klass.new(fixtures.photos,{:date => 222})
        }.to raise_error(ArgumentError)
      end
      it "raises an error when date is invalid string" do
        expect {
          klass.new(fixtures.photos,{:date => '2010'})
        }.to raise_error(ArgumentError)
      end
      it "raises an error when search_terms is an integer" do
        expect {
          klass.new(fixtures.photos,{:search_terms => 22})
        }.to raise_error(ArgumentError)
      end
    end
  end

  context "instance methods" do
    specify {subject.should respond_to(:search_terms)}
    context "#search_terms" do
      let(:search_terms){'shiraz,iran'}
      subject {klass.new(fixtures.photos,{:search_terms => search_terms})}

      it "returns expected has of search_terms" do
        subject.search_terms.should == search_terms
      end

      it "returns empty string when no search_terms supplied during initialization" do
        klass.new(fixtures.photos,{}).search_terms.should be_empty
      end
    end


    specify {subject.should respond_to(:page)}
    context "#page" do
      let(:page) {20}
      subject {klass.new(fixtures.photos,{:page => page})}
      it "returns expected page number when specified at initialization" do
        subject.page.should == page
      end
      it "returns 1 if no page specified at initialization" do
        klass.new(fixtures.photos,{}).page.should == 1
      end
    end

    specify {subject.should respond_to(:date)}
    context "#date" do
      let(:date) {'2010-09-10'}
      subject {klass.new(fixtures.photos,{:date => date})}
      it "returns expected date" do
        subject.date.should == date
      end
      it "returns nil when called on object with no :date specified" do
        klass.new(fixtures.photos,{}).date.should be_nil
      end
    end

    specify {subject.should respond_to(:total_results)}
    context "#total_results" do
      it "returns same value as #total_entries" do
        subject.total_results.should == subject.total_entries
      end
    end

    specify {subject.should respond_to(:capped_entries)}
    context "#capped_entries" do
      it "returns same as total_entries when <= max_entries" do
        subject.photos.stub(:total_entries).and_return(subject.photos.max_entries() -1)
        subject.capped_entries.should == subject.photos.capped_entries
      end
      it "returns max_entries when total_entries > max_entries" do
        subject.photos.stub(:total_entries).and_return(subject.photos.max_entries()+1)
        subject.capped_entries.should == subject.photos.capped_entries
      end
    end


    specify{subject.should respond_to(:url_params)}
    context "url_params" do
      it "returns expected parameters when all options specified" do
        options = {:date => '2010-12-20', :search_terms => 'iran,shiraz'}
        klass.new(fixtures.photos,options).url_params.should == options
      end
      it "returns only search_terms when only search_terms is specified" do
        options = {:date => nil, :search_terms => 'iran,shiraz'}
        klass.new(fixtures.photos,options).url_params.should == {:search_terms => 'iran,shiraz'}
      end
      it "returns yesterday for date when no options are specified" do
        options = {:date => nil, :search_terms => nil}
        klass.new(fixtures.photos,options).url_params.should == {:date => api::Helpers.date}
      end
      it "returns date when valid date and no search terms is provided" do
        options = {:date => '2010-01-01', :search_terms => nil}
        klass.new(fixtures.photos,options).url_params.should == {:date => '2010-01-01'}
      end
    end

    specify {subject.should respond_to(:==)}
    context "#==" do
      it "returns true when object is compared to itself" do
        subject.should == subject
      end
      it "returns true when object is compared to clone of itself" do
        subject.should == subject.clone
      end
      it "returns false when object compared to an Array" do
        subject.should_not == []
      end
      it "returns false when object is compared to an object with a single difference" do
        other = subject.clone
        other.photos.last.instance_eval('@delegated_to_object').instance_eval('@h["server"]="1234321"')
        subject.should_not == other
      end
    end

    context "methods delegated to other object" do
      context "methods delegated to photos object" do
        it "returns identical results as direct call to photos object" do
          klass.delegated_instance_methods.each do |method|
            subject.send(method).should == subject.photos.send(method)
          end
        end
      end
      
      specify {subject.should respond_to(:collection)}
      context "#collection" do
        context "usable photos set to nil" do
        let(:reference){
          OpenStruct.new :current_page => subject.current_page,
          :per_page => subject.per_page,
          :total_entries => subject.capped_entries,
          :collection => subject.photos
        }
        it_behaves_like "object that responds to collection"
      end
      
      context "usable photos set to true" do
        subject { klass.new fixtures.interesting_photos,options }
        let(:collection){subject.photos.clone.keep_if do |p| p.license.to_i > 3 end}
        let(:reference) {
          OpenStruct.new :current_page => 1,
          :per_page => subject.perpage,
          :total_entries => collection.length,
          :collection => collection
        }
        it_behaves_like "object that responds to collection with usable option"
      end

    end


      context "array accessor methods" do
        let(:reference){subject.photos}
        it_behaves_like "object with delegated Array accessor helpers"
      end
    end
  end


  context "metaprogramming methods" do
    specify {subject.should respond_to(:methods)}
    context "#methods" do
      it "return complete list that including the delegated_instance_methods" do
        subject.methods.sort.should == (subject.old_methods +
            subject.delegated_instance_methods).sort
      end
    end

    specify {subject.should respond_to(:respond_to?)}
    context "respond_to?" do
      it "return true for all methods returned by #methods" do
        subject.methods.each do |method|
          subject.should respond_to(method)
        end
      end
    end

    specify {subject.should respond_to(:delegated_instance_methods)}
    context "#delegated_instance_methods" do
      it "returns array accessor methods as well as other methods delegated to photos" do
        subject.delegated_instance_methods.sort.should == (models::PhotoSearch.delegated_instance_methods +
           models::Helpers.array_accessor_methods).sort
      end
    end
  end


  context "custom cloning methods" do
    context "initialization" do
      it "returns photos with independent indices" do
        other = subject.clone
        subject.photos.each_index do |index|
          subject.photos[index].__id__.should_not == other.photos[index].__id__
        end
      end
    end
  end

end