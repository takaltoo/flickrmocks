module FlickrMocks
  class PhotoSize < SimpleDelegator
    def initialize(size)
      raise TypeError, 'FlickRaw::Response expected' unless size.is_a? FlickRaw::Response
      super
    end

    def id
      source.split('/')[-1].split('_')[0]
    end

  end
end