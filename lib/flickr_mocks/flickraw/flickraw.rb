module FlickRaw

  class Response
    include FlickrMocks::CustomMarshal
    include FlickrMocks::CustomCompare
    include FlickrMocks::CustomClone
  end

  class ResponseList
    include FlickrMocks::CustomMarshal
    include FlickrMocks::CustomCompare
    include FlickrMocks::CustomClone
  end
end
