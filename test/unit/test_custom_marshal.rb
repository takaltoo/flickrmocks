require File.expand_path(File.dirname(__FILE__) + '/../helper')

class TestFlickrMocks_CustomMarshal < Test::Unit::TestCase
  context 'FlickrMocks::CustomMarshal methods' do
    setup do
      @h = FlickrMocks::Helpers
      @f = FlickrMocks::Fixtures.new
    end
    
    # indirectly tests _dump/_load 
    should 'custom _dump/_load for FlickRaw::Response/List enables marshaling and unmarshaling' do
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photos)),@f.photos), 'marshal/unmarshal same object should not change object'
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photo_sizes)),@f.photo_sizes), 'marshal/unmarshal same object should not change object'
      assert @h.equivalent?(Marshal.load(Marshal.dump(@f.photo_details)),@f.photo_details), 'marshal/unmarshal same object should not change object'
      assert @h.equivalent?(Marshal.load(Marshal.dump(Marshal.load(Marshal.dump(@f.photos)))),@f.photos), 'multiple marshal/unmarshal should not change object'
    end
  end
end