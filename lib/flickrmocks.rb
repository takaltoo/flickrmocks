require 'active_resource' unless defined?(ActiveResource)
require 'chronic'

require 'find'
require 'delegate'



# Use user specified FlickRaw definition, if not defined use flickraw-cached if
#   available
begin
  require 'flickraw-cached' unless defined?(FlickRaw)
rescue LoadError
  require 'flickraw'
end

  

  flickrmocks_path = File.expand_path('../flickr_mocks/', __FILE__)


# include all ruby files in the library path
 Find.find(flickrmocks_path) do |file|
  if File.file?(file)
    require file if File.extname(file) == '.rb'
  end
 end
