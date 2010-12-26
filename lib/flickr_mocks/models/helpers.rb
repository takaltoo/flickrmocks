module FlickrMocks
  module Models

    # module contains methods that are used internally by the various class wrappers
    # for the FlickRaw::Response and FlickRaw::ResponseList objects.
    module Helpers
      # returns list of array methods. These methods are often used for mimicking
      # array like behavior to classes.
      def self.array_accessor_methods
        [:[], :first, :last,:empty?,:length,:size,:each,:each_index,
         :each_with_index,:map, :select, :keep_if,:at,:fetch, :reverse_each,
         :find_index, :index,:rindex, :collect,:values_at]
      end


      # returns the default values for paging Flickr objects
      def self.paging_defaults
        {
          :max_entries => ::FlickrMocks::Api.default(:max_entries).to_i,
          :per_page => ::FlickrMocks::Api.default(:per_page).to_i,
          :current_page => ::FlickrMocks::Api.default(:page).to_i
        }
      end
      
      # returns list of sizes that a Flickr photo can have
      def self.possible_sizes
        ::FlickrMocks::Api.default(:possible_sizes)
      end
    end
  end
end
