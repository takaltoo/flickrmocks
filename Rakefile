require 'rubygems'
require 'rake'
require File.expand_path(File.dirname(__FILE__) + '/lib/flickrmocks')

# include all tasks
Dir.glob("tasks/*.rb").each do |file|
  require File.expand_path(File.dirname(__FILE__) + "/#{file}")
end


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
    gem.add_dependency 'activeresource', "=2.3.9" 
    gem.add_dependency 'chronic'
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



