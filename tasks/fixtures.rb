require File.expand_path(File.dirname(__FILE__) + '/../lib/flickrmocks')
require 'fileutils'
require 'ruby-debug'


# used for providing fixtures to users of the gem
namespace :fixtures do
  desc 'generate all fixtures for USERS of the GEM'
  task :all => [:photos,:empty_photos,:interesting_photos,:author_photos,
                    :photo,:photo_details,:photo_sizes,:photo_size,:expected_methods,
                    :commons_institutions,:commons_institution_photos]
  
  desc 'generate fixture for flickr.photos.search'
  task :photos => :repository do
    config_flickr
    dump default_photos,:photos
  end

  desc 'generated fixture for empty flickr.photos.search'
  task :empty_photos => :repository do
    config_flickr
    dump default_empty_photos, :empty_photos
  end


  desc 'generate fixture for flickr.interestingness.getList'
  task :interesting_photos => :repository do
    config_flickr
    dump default_interesting_photos,:interesting_photos
  end

  desc 'generate fixture for flickr.photos.search :author'
  task :author_photos => :repository do
    config_flickr
    dump default_author_photos,:author_photos
  end

  desc 'generating photo'
  task :photo => :repository do
    config_flickr
    dump default_photo,:photo
  end

  desc 'generated fixture for flickr.photos.getInfo'
  task :photo_details => :repository do
    config_flickr
    dump default_photo_details,:photo_details
  end

  desc 'generate fixture for flickr.photos.getSizes'
  task :photo_sizes => :repository do
    config_flickr
    dump default_photo_sizes,:photo_sizes
  end

  desc 'generate fixture for single size'
  task :photo_size => :repository do
    config_flickr
    dump default_photo_sizes[0],:photo_size
  end

  desc 'generate fixture for commons institutions'
  task :commons_institutions => :repository do
    config_flickr
    dump default_commons_institutions, :commons_institutions
  end

  desc 'generate fixture for commons institution photos'
  task :commons_institution_photos => :repository do
    config_flickr
    dump default_commons_institution_photos, :commons_institution_photos
  end
  

  desc 'expected methods'
  task :expected_methods => :repository do
    data = OpenStruct.new
    config_flickr
    data.photos = default_methods(default_photos)
    data.empty_photos = default_methods(default_empty_photos)
    data.interesting_photos = default_methods(default_interesting_photos)
    data.author_photos = default_methods(default_author_photos)
    data.photo = default_methods(default_photo)
    data.photo_details = default_methods(default_photo_details)
    data.photo_sizes = default_methods(default_photo_sizes)
    data.photo_size = default_methods(default_photo_size)
    data.commons_institutions = default_methods(default_commons_institutions)
    data.commons_institution_photos = default_methods(default_commons_institution_photos)
    dump data,:expected_methods
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
    config_dir + '/spec/fixtures/'
  end

  def dump(data,fname)
    puts "generating file #{fname}"
    file = repo_dir + fname.to_s + '.marshal'
    FlickrMocks::Helpers.dump data,file
  end

  def default_photos
    @default_photos ||= flickr.photos.search :tags => 'france', :per_page => '50', :extras=>'license'
    @default_photos
  end

  def default_interesting_photos
    @default_intesting_photos ||= flickr.interestingness.getList :date => '2009-01-15', :per_page => '50', :extras=>'license'
    @default_intesting_photos
  end

  def default_author_photos
    @default_author_photos ||= flickr.photos.search :user_id => default_photo.owner, :per_page => '20', :extras=>'license'
    @default_author_photos
  end

  def default_photo
    @default_photo ||=  default_photos[0]
    @default_photo
  end

  def default_photo_details
    @default_photo_details ||= flickr.photos.getInfo :photo_id => default_photo.id, :extras=>'license'
    @default_photo_details
  end

  def default_photo_sizes
    @default_photo_sizes ||=flickr.photos.getSizes :photo_id => default_photo.id, :extras=> 'license'
    @default_photo_sizes
  end

  def default_photo_size
    @default_photo_size ||= default_photo_sizes[0]
    @default_photo_size
  end

  def default_empty_photos
    @default_empty_photos ||= flickr.photos.search :tags => 'xyzgoogohowdy'
    @default_empty_photos
  end

  def default_commons_institutions
    @default_commons_institutions ||= flickr.commons.getInstitutions
    @default_commons_institutions
  end

  def default_commons_institution_photos
    @default_commons_institution_photos ||= flickr.photos.search :user_id  => '35532303@N08', :per_page => '200', :extras=>'license'
    @default_commons_institution_photos
  end
  
  def default_methods(obj)
    obj.methods.include?(:flickr_type) ? obj.methods(false).push(:flickr_type) : obj.methods(false)
  end
  
end
