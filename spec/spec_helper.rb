require 'rubygems'
require 'rspec'
require 'faker'
require 'flickraw-cached'
require 'ruby-debug'
require 'shared_examples/array_accessor'
require 'shared_examples/image_url_helpers'
require 'shared_examples/size_accessor'
require 'shared_examples/collection'
require 'shared_examples/hash_argument'
require 'shared_examples/stub_helpers'
require 'shared_examples/hash_options/perpage_hash_option'
require 'shared_examples/hash_options/page_hash_option'
require 'shared_examples/hash_options/tag_mode_hash_option'
require 'shared_examples/hash_options/date_hash_option'
require 'flickrmocks'

Rspec.configure do |c|
  #  c.mock_with :mocha
  APP = FlickrMocks
end


