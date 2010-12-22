# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flickr_mocks/version"

Gem::Specification.new do |s|
  s.name        = "flickrmocks"
  s.version     = FlickrMocks::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Takaltoo"]
  s.email       = ["pouya@lavabit.com"]
  s.homepage    = "http://rubygems.org/gems/flickrmocks"
  s.summary     = %q{Sample gem to see if can do a bundle based gem}
  s.description = %q{FlickrMocks makes it possible to Marshal responses
       generated from the FLickRaw gem. This is useful for
			 Mocking/Stubbing the Flickr interface for testing purposes.
		   The FlickRaw::Response and FlickRaw::ResponseList objects can
			 not be Marshaled because they contain singleton's.}
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "flickrmocks"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency(%q<flickraw>, [">= 0.8.2"])
  s.add_runtime_dependency(%q<chronic>, [">= 0"])
  s.add_runtime_dependency(%q<ruby-debug19>, [">= 0.11.6"])
  s.add_runtime_dependency(%q<will_paginate>, [">= 3.0.pre2"])
  s.add_development_dependency(%q<rspec>, [">= 2.2.0"])
  s.add_development_dependency(%q<factory_girl_rails>, [">= 1.0"])
  s.add_development_dependency(%q<faker>, [">= 0.3.1"])
  s.add_development_dependency(%q<flickraw-cached>, [">= 0.8.2"])
end

