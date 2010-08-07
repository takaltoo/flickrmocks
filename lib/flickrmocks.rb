require 'find'
require 'flickraw-cached'

flickrmocks_path = File.expand_path('../flickr_mocks/', __FILE__)


# include all ruby files in the library path
Find.find(flickrmocks_path) do |file|
  if File.file?(file)
    require file if File.extname(file) == '.rb'
  end
end
