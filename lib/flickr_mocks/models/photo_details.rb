module FlickrMocks
  class PhotoDetails < SimpleDelegator
    attr_reader :sizes

    def initialize(photo,sizes)
      raise TypeError, 'FlickRaw::Response expected' unless photo.is_a?(FlickRaw::Response) || photo.is_a?(Photo)
      raise TypeError, 'FlickRaw::Response expected' unless sizes.is_a?(PhotoSizes) || sizes.is_a?(FlickRaw::ResponseList)
      @sizes = sizes.class == FlickrMocks::PhotoSizes ?  sizes : PhotoSizes.new(sizes)
      super(photo.is_a?(Photo) ?  photo : Photo.new(photo)  )
    end

    def author
      self.owner.realname
    end

    # requires originalsecret which is in the detail view but not generic
    def original
      FlickRaw.url_o self
    end

  end
end