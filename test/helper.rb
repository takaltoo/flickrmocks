require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'flickraw-cached'
require 'mocha'
require 'chronic_duration'

$LOAD_PATH.unshift(File.dirname(__FILE__))
require File.expand_path(File.dirname(__FILE__) + '/../lib/flickrmocks')

FlickrFixtures = FlickrMocks::Fixtures.new



