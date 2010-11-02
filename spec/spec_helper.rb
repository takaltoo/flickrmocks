require 'rubygems'
require 'rspec'

require 'faker'

require 'chronic_duration'
require 'flickraw-cached'
require 'ruby-debug'

require 'shared_examples/array_accessor'
require 'shared_examples/image_url_helpers'
require 'shared_examples/size_accessor'
require 'shared_examples/collection'

require 'flickrmocks'

Rspec.configure do |c|
#  c.mock_with :mocha

  APP = FlickrMocks
  FlickrFixtures = APP::Fixtures.new
end


