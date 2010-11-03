module FlickrMocks
  module Models
    module Helpers
      def self.array_accessor_methods
        [:[], :at,:fetch, :first, :last,:each,
          :each_index, :reverse_each,:length, :size,
          :empty?, :find_index, :index,:rindex, :collect,
          :map, :select, :keep_if, :values_at]
      end
      def self.possible_sizes
        [:square, :thumbnail, :small, :medium, :medium_640, :large, :original]
      end
    end
  end
end
