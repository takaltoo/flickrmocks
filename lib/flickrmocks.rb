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

[
 'flickr_mocks/version.rb',
 'flickr_mocks/stubs.rb',
 'flickr_mocks/helpers.rb',
 'flickr_mocks/fixtures.rb',
 'flickr_mocks/models/helpers.rb',
 'flickr_mocks/models/photo_sizes.rb',
 'flickr_mocks/models/photo_dimensions.rb',
 'flickr_mocks/models/photo_size.rb',
 'flickr_mocks/models/photos.rb',
 'flickr_mocks/models/photo.rb',
 'flickr_mocks/models/photo_search.rb',
 'flickr_mocks/models/photo_details.rb',
 'flickr_mocks/models/commons_institutions.rb',
 'flickr_mocks/models/commons_institution.rb',
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

