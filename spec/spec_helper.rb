require 'rubygems'
require 'rspec'
require 'mocha'

require 'faker'

require 'chronic_duration'
require 'flickraw-cached'
require 'ruby-debug'



require 'flickrmocks'

Rspec.configure do |c|
  c.mock_with :mocha

  APP = FlickrMocks
  FlickrFixtures = APP::Fixtures.new
end


