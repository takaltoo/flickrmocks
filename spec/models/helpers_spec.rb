require 'spec_helper'

describe APP::Models::Helpers do
  let(:klass) {APP::Models::Helpers}
  context "class methods" do

    specify {klass.should respond_to(:array_accessor_methods)}
    context "array_accessor_methods" do
      it "returns expected array methods" do
        klass.array_accessor_methods.sort.should ==  [:[], :at,:fetch, :first, :last,:each,
          :each_index, :reverse_each,:length, :size,
          :empty?, :find_index, :index, :each_with_index,:rindex, :collect,
          :map, :select, :keep_if, :values_at].sort
      end
    end

    specify {klass.should respond_to(:possible_sizes)}
    context "possible_sizes" do
      it "returns expected array of possible image sizes" do
        klass.possible_sizes.should == [:square, :thumbnail, :small, :medium,
          :medium_640, :large, :original]
      end
    end
    
    specify {klass.should respond_to(:paging_defaults)}
    context "paging_defaults" do
      it "returns expected hash of paging defaults" do
        klass.paging_defaults.should == {
          :max_entries => 4000,
          :per_page => 50,
          :current_page => 1
        }
      end
    end
    
  end
end
