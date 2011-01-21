require 'chronic'

require 'find'
require 'delegate'
require 'cgi'

require 'will_paginate/collection'

# Use user specified FlickRaw definition, if not defined use flickraw-cached if
#   available
begin
  require 'flickraw-cached' unless defined?(FlickRaw)
rescue LoadError
  require 'flickraw'
end

  

#  flickrmocks_path = File.expand_path('../flickr_mocks/', __FILE__)
#
#
## include all ruby files in the library path
# Find.find(flickrmocks_path) do |file|
#  if File.file?(file)
#    require file if File.extname(file) == '.rb'
#  end
# end
module FlickrMocks  
  autoload :VERSION,  'flickr_mocks/version'
  autoload :Stubs, 'flickr_mocks/stubs' 
  autoload :Helpers, 'flickr_mocks/helpers'
  autoload :Fixtures, 'flickr_mocks/fixtures'
  
  
  # wrapper module that contains the classes that wrap the FlickRaw::Response and
  # FlickRaw::ResponseList objects.
  module Models
    autoload :Helpers, 'flickr_mocks/models/helpers'
    autoload :PhotoSizes, 'flickr_mocks/models/photo_sizes'
    autoload :PhotoDimensions, 'flickr_mocks/models/photo_dimensions'
    autoload :PhotoSize, 'flickr_mocks/models/photo_size'
    autoload :Photos, 'flickr_mocks/models/photos'
    autoload :Photo, 'flickr_mocks/models/photo'
    autoload :PhotoSearch, 'flickr_mocks/models/photo_search'
    autoload :PhotoDetails, 'flickr_mocks/models/photo_details'
    autoload :CommonsInstitutions, 'flickr_mocks/models/commons_institutions'
    autoload :CommonsInstitution, 'flickr_mocks/models/commons_institution'    
  end
  
end

[          
 'flickr_mocks/api/helpers.rb',
 'flickr_mocks/api/options.rb',
 'flickr_mocks/api/flickr.rb',
 'flickr_mocks/api/sanitize.rb',
 'flickr_mocks/api/api.rb',
 'flickr_mocks/flickraw/custom_clone.rb',
 'flickr_mocks/flickraw/custom_compare.rb',
 'flickr_mocks/flickraw/custom_marshal.rb',
 'flickr_mocks/flickraw/flickraw.rb'
].each do |file|
 require File.expand_path(File.dirname(__FILE__)) + '/' + file
end

