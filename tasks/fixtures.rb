require File.expand_path(File.dirname(__FILE__) + '/../lib/flickrmocks')
require 'fileutils'

# used for providing fixtures to users of the gem
namespace :fixtures do
  desc 'generate all fixtures for USERS of the GEM'
  task :all => [:photos,:sizes,:details,:interesting, :author_photos]

  desc 'generate fixture for flickr.interestingness.getList'
  task :interesting => :repository do
    puts 'generating interesting photos'
    config_flickr
    data = flickr.interestingness.getList :date => '2010-08-18', :per_page => '50', :extras=>'license'
    dump data,repo_dir + 'interesting_photos.marshal'
  end


  desc 'generate fixture for flickr.photos.search'
  task :photos => :repository do
    puts "generating photos"
    config_flickr
    data = flickr.photos.search :tags => 'iran', :per_page => '5', :extras=>'license'
    dump data,repo_dir + 'photos.marshal'
  end
  
  desc 'generate fixture for flickr.photos.search :author'
  task :author_photos => :repository do
    puts "generating photos"
    config_flickr
    data = flickr.photos.search :user_id => '8070463@N03', :per_page => '20', :extras=>'license'
    dump data,repo_dir + 'author_photos.marshal'
  end

  desc 'generate fixture for flickr.photos.getSizes'
  task :sizes => :repository do
    puts "generating sizes"
    config_flickr
    data = flickr.photos.getSizes :photo_id => '4877807944', :extras=>'license'
    dump data,repo_dir + 'photo_sizes.marshal'
  end

  desc 'generated fixture for flickr.photos.getInfo'
  task :details => :repository do
    puts "generating photo details"
    config_flickr
    data = flickr.photos.getInfo :photo_id => '4877807944', :extras=>'license'
    dump data,repo_dir + 'photo_details.marshal'
  end

  desc 'create directory for string Fixtures for Users of gem'
  task :repository do
    repo = repo_dir
    unless File.exists? repo
      puts "generating directory #{repo}"
      FileUtils.mkdir_p repo
    end
  end

  desc 'removing all fixture files used by Users of the gem'
  task :clean do
    files = Dir.glob "#{repo_dir}*.marshal"
    if files.empty?
      puts 'nothing to remove'
    else
      puts "removing files #{files}"
      FileUtils.rm files
    end
  end


  # helper methods for configuration

  def config_flickr
    FlickRaw.api_key = YAML.load_file("#{config_dir}/config.yml")['flickr_api_key']
  end

  def config_dir
    File.expand_path(File.dirname(__FILE__) + '/../')
  end

  def repo_dir
    FlickrMocks::Fixtures.repository
  end

  def dump(data,fname)
    puts "generating file #{fname}"
    FlickrMocks::Helpers.dump data,fname
  end

end
