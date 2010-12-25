
# adds custom cloning, marshaling and compare methods to the FlickRaw::Response
# and FlickRaw::ResponseList class. These additional methods help in testing
# the FlickrMocks models.
module FlickRaw

  # adds custom cloning, marshaling and compare methods to FlickRaw::Response class
  class Response
    include FlickrMocks::CustomMarshal
    include FlickrMocks::CustomCompare
    include FlickrMocks::CustomClone
  end

  # adds custom cloning, marshaling and compare methods to FlickRaw::ResponseList class
  class ResponseList
    include FlickrMocks::CustomMarshal
    include FlickrMocks::CustomCompare
    include FlickrMocks::CustomClone
  end
end
