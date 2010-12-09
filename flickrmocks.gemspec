# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{flickrmocks}
  s.version = "0.8.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takaltoo"]
  s.date = %q{2010-12-08}
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
    ".autotest",
     ".document",
     ".gitignore",
     ".rspec",
     "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "autotest/discover.rb",
     "flickrmocks.gemspec",
     "lib/flickr_mocks/api/api.rb",
     "lib/flickr_mocks/api/flickr.rb",
     "lib/flickr_mocks/api/helpers.rb",
     "lib/flickr_mocks/api/options.rb",
     "lib/flickr_mocks/api/sanitize.rb",
     "lib/flickr_mocks/fixtures.rb",
     "lib/flickr_mocks/flickraw/custom_clone.rb",
     "lib/flickr_mocks/flickraw/custom_compare.rb",
     "lib/flickr_mocks/flickraw/custom_marshal.rb",
     "lib/flickr_mocks/flickraw/flickraw.rb",
     "lib/flickr_mocks/helpers.rb",
     "lib/flickr_mocks/models/commons_institution.rb",
     "lib/flickr_mocks/models/commons_institutions.rb",
     "lib/flickr_mocks/models/helpers.rb",
     "lib/flickr_mocks/models/photo.rb",
     "lib/flickr_mocks/models/photo_details.rb",
     "lib/flickr_mocks/models/photo_dimensions.rb",
     "lib/flickr_mocks/models/photo_search.rb",
     "lib/flickr_mocks/models/photo_size.rb",
     "lib/flickr_mocks/models/photo_sizes.rb",
     "lib/flickr_mocks/models/photos.rb",
     "lib/flickr_mocks/stubs.rb",
     "lib/flickr_mocks/version.rb",
     "lib/flickrmocks.rb",
     "spec/api/api_spec.rb",
     "spec/api/flickr_spec.rb",
     "spec/api/helper_spec.rb",
     "spec/api/options_spec.rb",
     "spec/api/sanitize_spec.rb",
     "spec/base/fixtures_spec.rb",
     "spec/base/flickraw/custom_clone_spec.rb",
     "spec/base/flickraw/custom_compare_spec.rb",
     "spec/base/flickraw/custom_marshal_spec.rb",
     "spec/base/helpers_spec.rb",
     "spec/base/stubs_spec.rb",
     "spec/base/version_spec.rb",
     "spec/fixtures/author_photos.marshal",
     "spec/fixtures/commons_institution_photos.marshal",
     "spec/fixtures/commons_institutions.marshal",
     "spec/fixtures/empty_photos.marshal",
     "spec/fixtures/expected_methods.marshal",
     "spec/fixtures/interesting_photos.marshal",
     "spec/fixtures/photo.marshal",
     "spec/fixtures/photo_details.marshal",
     "spec/fixtures/photo_size.marshal",
     "spec/fixtures/photo_sizes.marshal",
     "spec/fixtures/photos.marshal",
     "spec/models/commons_institution_spec.rb",
     "spec/models/commons_institutions_spec.rb",
     "spec/models/helpers_spec.rb",
     "spec/models/photo_details_spec.rb",
     "spec/models/photo_dimensions_spec.rb",
     "spec/models/photo_search_spec.rb",
     "spec/models/photo_size_spec.rb",
     "spec/models/photo_sizes_spec.rb",
     "spec/models/photo_spec.rb",
     "spec/models/photos_spec.rb",
     "spec/shared_examples/array_accessor.rb",
     "spec/shared_examples/collection.rb",
     "spec/shared_examples/image_url_helpers.rb",
     "spec/shared_examples/size_accessor.rb",
     "spec/spec_helper.rb",
     "tasks/fixtures.rb"
  ]
  s.homepage = %q{http://github.com/takaltoo/flickrmocks}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Enables FlickRaw responses to be Marshaled.}
  s.test_files = [
    "spec/shared_examples/array_accessor.rb",
     "spec/shared_examples/size_accessor.rb",
     "spec/shared_examples/collection.rb",
     "spec/shared_examples/image_url_helpers.rb",
     "spec/models/helpers_spec.rb",
     "spec/models/photo_details_spec.rb",
     "spec/models/photo_size_spec.rb",
     "spec/models/commons_institution_spec.rb",
     "spec/models/photo_sizes_spec.rb",
     "spec/models/commons_institutions_spec.rb",
     "spec/models/photos_spec.rb",
     "spec/models/photo_dimensions_spec.rb",
     "spec/models/photo_spec.rb",
     "spec/models/photo_search_spec.rb",
     "spec/api/api_spec.rb",
     "spec/api/flickr_spec.rb",
     "spec/api/options_spec.rb",
     "spec/api/sanitize_spec.rb",
     "spec/api/helper_spec.rb",
     "spec/base/stubs_spec.rb",
     "spec/base/helpers_spec.rb",
     "spec/base/version_spec.rb",
     "spec/base/flickraw/custom_clone_spec.rb",
     "spec/base/flickraw/custom_compare_spec.rb",
     "spec/base/flickraw/custom_marshal_spec.rb",
     "spec/base/fixtures_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.0.0.beta.22"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<factory_girl_rails>, [">= 1.0"])
      s.add_development_dependency(%q<faker>, [">= 0.3.1"])
      s.add_runtime_dependency(%q<flickraw>, [">= 0.8.2"])
      s.add_runtime_dependency(%q<chronic>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.0.beta.22"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<factory_girl_rails>, [">= 1.0"])
      s.add_dependency(%q<faker>, [">= 0.3.1"])
      s.add_dependency(%q<flickraw>, [">= 0.8.2"])
      s.add_dependency(%q<chronic>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.0.beta.22"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<factory_girl_rails>, [">= 1.0"])
    s.add_dependency(%q<faker>, [">= 0.3.1"])
    s.add_dependency(%q<flickraw>, [">= 0.8.2"])
    s.add_dependency(%q<chronic>, [">= 0"])
  end
end

