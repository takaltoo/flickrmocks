require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "flickrmocks"
    gem.summary = %Q{Enables FlickRaw responses to be Marshaled.}
    gem.description = %Q{FlickrMocks makes it possible to Marshal responses 
			 generated from the FLickRaw gem. This is useful for 
			 Mocking/Stubbing the Flickr interface for testing purposes.
		         The FlickRaw::Response and FlickRaw::ResponseList objects can 
			 not be Marshaled because they contain singleton's.}
    gem.email = "pouya@lavabit.com"
    gem.homepage = "http://github.com/takaltoo/flickrmocks"
    gem.authors = ["Takaltoo"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 2.10"
    gem.add_dependency "flickraw", ">=0.8.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "flickrmocks #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


# tasks for
desc "Helpers for updating mocks required for testing utility"
namespace :mocks do
  task :update => :config do
   
    mdir = @config_dir + '/test/mocks/'
    require "#{@config_dir + '/lib/flickrmocks'}"

    h = FlickrMocks::Helpers
    FlickRaw.api_key= @config['flickr_api_key']

    photos = flickr.photos.search :tags => 'iran', :per_page => '4'
    h.marshal(h.marshal_dump(photos),mdir+'photos.marshal')
    
    details = flickr.photos.getInfo :photo_id => photos[0].id, :secret => photos[0].secret
    h.marshal(h.marshal_dump(details),mdir+'photo_details.marshal')

    sizes = flickr.photos.getSizes :photo_id => photos[0].id, :secret => photos[0].secret
    h.marshal(h.marshal_dump(sizes),mdir+'sizes.marshal')
  end

  desc "load yml configuration file for flickr api"
  task :config => :config_file do
    @config_dir = File.dirname(File.expand_path(__FILE__))
    @config = YAML.load_file("#{@config_dir}/config.yml")
  end

  desc "generate configuration file"
  task :config_file do
    file = 'config.yml'
    unless File.exists?(file)
      sh "touch #{file}"
      sh "echo 'flickr_api_key: 247c5c08074816140d8ee7e74ef101e1' >> #{file} "
    end
  end
  directory "test/mocks"


end
