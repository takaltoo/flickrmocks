# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flickrmocks}
  s.version = "0.7.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takaltoo"]
  s.date = %q{2010-09-06}
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
     "lib/flickr_mocks/api/api.rb",
     "lib/flickr_mocks/api/flickr.rb",
     "lib/flickr_mocks/api/helpers.rb",
     "lib/flickr_mocks/api/options.rb",
     "lib/flickr_mocks/api/sanitize.rb",
     "lib/flickr_mocks/api/time.rb",
     "lib/flickr_mocks/custom_marshal.rb",
     "lib/flickr_mocks/fixtures.rb",
     "lib/flickr_mocks/flickraw.rb",
     "lib/flickr_mocks/helpers.rb",
     "lib/flickr_mocks/models/pages.rb",
     "lib/flickr_mocks/models/photo.rb",
     "lib/flickr_mocks/models/photo_details.rb",
     "lib/flickr_mocks/models/photo_size.rb",
     "lib/flickr_mocks/models/photo_sizes.rb",
     "lib/flickr_mocks/models/photos.rb",
     "lib/flickr_mocks/version.rb",
     "lib/flickrmocks.rb",
     "tasks/fixtures.rb",
     "test/fixtures/author_photos.marshal",
     "test/fixtures/interesting_photos.marshal",
     "test/fixtures/photo_details.marshal",
     "test/fixtures/photo_sizes.marshal",
     "test/fixtures/photos.marshal",
     "test/helper.rb",
     "test/unit/api/test_api.rb",
     "test/unit/api/test_helper.rb",
     "test/unit/api/test_options.rb",
     "test/unit/api/test_sanitize.rb",
     "test/unit/api/test_time.rb",
     "test/unit/models/test_pages.rb",
     "test/unit/models/test_photo.rb",
     "test/unit/models/test_photo_details.rb",
     "test/unit/models/test_photo_size.rb",
     "test/unit/models/test_photo_sizes.rb",
     "test/unit/models/test_photos.rb",
     "test/unit/test_custom_marshal.rb",
     "test/unit/test_fixtures.rb",
     "test/unit/test_helpers.rb",
     "test/unit/test_version.rb"
  ]
  s.homepage = %q{http://github.com/takaltoo/flickrmocks}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Enables FlickRaw responses to be Marshaled.}
  s.test_files = [
    "test/unit/test_fixtures.rb",
     "test/unit/models/test_photo_details.rb",
     "test/unit/models/test_pages.rb",
     "test/unit/models/test_photos.rb",
     "test/unit/models/test_photo_size.rb",
     "test/unit/models/test_photo.rb",
     "test/unit/models/test_photo_sizes.rb",
     "test/unit/test_version.rb",
     "test/unit/api/test_helper.rb",
     "test/unit/api/test_time.rb",
     "test/unit/api/test_api.rb",
     "test/unit/api/test_sanitize.rb",
     "test/unit/api/test_options.rb",
     "test/unit/test_helpers.rb",
     "test/unit/test_custom_marshal.rb",
     "test/helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
      s.add_runtime_dependency(%q<flickraw>, [">= 0.8.2"])
      s.add_runtime_dependency(%q<activeresource>, ["= 2.3.9"])
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
      s.add_dependency(%q<flickraw>, [">= 0.8.2"])
      s.add_dependency(%q<activeresource>, ["= 2.3.9"])
      s.add_dependency(%q<chronic>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 2.10"])
    s.add_dependency(%q<flickraw>, [">= 0.8.2"])
    s.add_dependency(%q<activeresource>, ["= 2.3.9"])
    s.add_dependency(%q<chronic>, [">= 0"])
  end
end

