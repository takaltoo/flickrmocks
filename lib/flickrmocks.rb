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

require 'flickr_mocks/version.rb'
require 'flickr_mocks/stubs.rb'
require 'flickr_mocks/helpers.rb'
require 'flickr_mocks/fixtures.rb'

require 'flickr_mocks/models/helpers.rb'
require 'flickr_mocks/models/photo_sizes.rb'
require 'flickr_mocks/models/photo_dimensions.rb'
require 'flickr_mocks/models/photo_size.rb'
require 'flickr_mocks/models/photos.rb'
require 'flickr_mocks/models/photo.rb'
require 'flickr_mocks/models/photo_search.rb'
require 'flickr_mocks/models/photo_details.rb'

require 'flickr_mocks/api/helpers.rb'
require 'flickr_mocks/api/options.rb'
require 'flickr_mocks/api/flickr.rb'
require 'flickr_mocks/api/sanitize.rb'
require 'flickr_mocks/api/api.rb'

require 'flickr_mocks/flickraw/custom_clone.rb'
require 'flickr_mocks/flickraw/custom_compare.rb'
require 'flickr_mocks/flickraw/custom_marshal.rb'
require 'flickr_mocks/flickraw/flickraw.rb'

