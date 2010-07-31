require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'flickraw-cached'
require 'ruby-debug'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'flickrmocks'

def load_flickr_response(file)
    fname = File.dirname(__FILE__) + '/mocks/' + file.to_s + '.marshal'
    FlickrMocks::Helpers.unmarshal fname
end


