# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flickrmocks}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takaltoo"]
  s.date = %q{2010-08-09}
  s.description = %q{FlickrMocks makes it possible to Marshal responses 
			 generated from the FLickRaw gem. This is useful for 
			 Mocking/Stubbing the Flickr interface for testing purposes.
		         The FlickRaw::Response and FlickRaw::ResponseList objects can 
			 not be Marshaled because they contain singleton's.}
  s.email = %q{pouya@lavabit.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "flickrmocks.gemspec",
     "lib/flickr_mocks/custom_marshal.rb",
     "lib/flickr_mocks/flickraw.rb",
     "lib/flickr_mocks/helpers.rb",
     "lib/flickrmocks.rb",
     "test/helper.rb",
     "test/mocks/photo_details.marshal",
     "test/mocks/photos.marshal",
     "test/mocks/sizes.marshal",
     "test/test_helpers.rb"
  ]
  s.homepage = %q{http://github.com/takaltoo/flickrmocks}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Enables FlickRaw responses to be Marshaled.}
  s.test_files = [
    "test/helper.rb",
     "test/test_helpers.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
      s.add_runtime_dependency(%q<flickraw>, [">= 0.8.2"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
      s.add_dependency(%q<flickraw>, [">= 0.8.2"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
    s.add_dependency(%q<flickraw>, [">= 0.8.2"])
  end
end

