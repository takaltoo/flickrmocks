module FlickrMocks
  module Models
    module Helpers

      def self.array_accessor_methods
        [:[], :first, :last,:empty?,:length,:size,:each,:each_index,
         :each_with_index,:map, :select, :keep_if,:at,:fetch, :reverse_each,
         :find_index, :index,:rindex, :collect,:values_at]
      end

      def self.paging_defaults
        {
          :max_entries => 4000,
          :per_page => 50,
          :current_page => 1
        }
      end

      def self.possible_sizes
        [:square, :thumbnail, :small, :medium, :medium_640, :large, :original]
      end
    end
  end
end
