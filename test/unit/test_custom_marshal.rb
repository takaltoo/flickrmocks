require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_CustomMarshal < Test::Unit::TestCase
  context '_dump and _load' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end
    
    # indirectly tests _dump/_load 
    should 'be able to Marshal/Un-Marshal Photos' do
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photos)),@f.photos), 'Photos properly marshaled and unmarshaled'
    end
    should 'be able to Marshal/Un-Marshal PhotoSizes' do
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photo_sizes)),@f.photo_sizes), 'PhotoSizes properly marshaled and un-marshaled'
    end
    should 'be able to Marashal/Un-Marshal PhotoDetails' do
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photo_details)),@f.photo_details), 'PhotoDetails properly marshaled and un-marshaled'
    end
    should 'be able to Marshal/Un-Marshal Photos' do
      assert @h.equivalent?(Marshal.load(Marshal.dump(Marshal.load(Marshal.dump(@f.photos)))),@f.photos), 'Photos properly marshaled and un-marshaled'
    end
  end
end