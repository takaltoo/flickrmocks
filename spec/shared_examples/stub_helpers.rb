
shared_examples_for "stub for Api.photo" do
  it "returns Photo object populated with fixtures.photo_details when valid id provided" do
    APP::Api.photo(:photo_id => 'detail').should == APP::Photo.new(fixtures.photo_details)
  end
  
  context "error conditions" do
    let(:subject){api}
    let(:method){:photo}
    it_behaves_like "object that expects single Hash argument"
    it_behaves_like "flickr api stub that requires :photo_id key in options hash"
  end
end


shared_examples_for "stub for Api.photos" do
  it "returns PhotoSearch object populated with fixtures.photos with valid tag" do
    APP::Api.photos(:tags => 'france').should == APP::PhotoSearch.new(fixtures.photos,APP::Api.search_params(:tags => 'france'))
  end
  
  context "owner_id provided" do
    it "returns object with same user when owner_id provided" do
      params = {:owner_id => '1'}
      api.photos(:owner_id => '1').should ==
        ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params(params))
    end
    it "returns object with same user when owner_id and tags provided" do
      params = {:owner_id => '1',:search_terms => 'iran'}
      api.photos(:owner_id => '1').should ==
        ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params({:owner_id => '1'}))
    end
    it "returns object with no entries when owner_id set to  'garbage'" do
      api.photos(:owner_id => 'garbage').should ==
        ::FlickrMocks::PhotoSearch.new(fixtures.empty_photos,api.search_params({:owner_id => 'garbage'}))
    end
  end

  context "search_terms provided" do
    it "returns object with different owner_id values when :search_terms provided" do
      params = {:search_terms => 'iran'}
      api.photos(params).should ==
        ::FlickrMocks::PhotoSearch.new(fixtures.photos,api.search_params(params))
    end
    it "returns object with no entries when :search_terms is set to 'garbage'" do
      params = {:search_terms => 'garbage'}
      api.photos(params).should ==
        ::FlickrMocks::PhotoSearch.new(fixtures.empty_photos,api.search_params(params))
    end
  end
  context "error conditions" do
    let(:subject){api}
    let(:method){:photos}
    it_behaves_like "object that expects single Hash argument"
  end
end

shared_examples_for "stub for Api.photo_details" do
  it "returns PhotoDetails object populated with fixtures.photo_details and fixtures.photo_sizes with valid :photo_id" do
    details = FlickrMocks::Photo.new(fixtures.photo_details)
    sizes = FlickrMocks::PhotoSizes.new(fixtures.photo_sizes)
    APP::Api.photo_details(:photo_id => 'sample').should == APP::PhotoDetails.new(details,sizes)
  end
  it "returns expected object when proper :photo_id provided" do
    api.photo_details(:photo_id => '1234').should ==
      ::FlickrMocks::PhotoDetails.new(fixtures.photo_details,fixtures.photo_sizes)
  end
  context "error conditions" do
    let(:subject){api}
    let(:method){:photo_details}
    it_behaves_like "object that expects single Hash argument"
  end
end

shared_examples_for "stub for Api.photo_sizes" do
  it "returns PhotoSizes object populated with fixtures.photo_sizes with valid :photo_id" do
    api.photo_sizes(:photo_id => '1234').should ==
      ::FlickrMocks::PhotoSizes.new(fixtures.photo_sizes)
  end
  context "error conditions" do
    let(:subject){api}
    let(:method){:photo_details}
    it_behaves_like "object that expects single Hash argument"
    it_behaves_like "flickr api stub that requires :photo_id key in options hash"
  end
end

shared_examples_for "stub for Api.interesting_photos" do
  it "returns PhotoSearch object when called with valid :date" do
    api.interesting_photos(:date => '2010-10-20').should ==
      FlickrMocks::PhotoSearch.new(fixtures.interesting_photos,FlickrMocks::Api.interesting_params(:date => '2010-10-20'))
  end
  it "returns PhotoSearch object when called without a :date" do
    api.interesting_photos({}).should ==
      FlickrMocks::PhotoSearch.new(fixtures.interesting_photos,FlickrMocks::Api.interesting_params({}))
  end
  it "returns empty photos when date is set to '2000-01-01" do
    params = {:date => '2000-01-01'}
     api.interesting_photos(params).should ==
       FlickrMocks::PhotoSearch.new(fixtures.empty_photos,FlickrMocks::Api.interesting_params(params))
  end

  context "error conditions" do
    it_behaves_like "object that expects single Hash argument"
    it "raises eror when :date is set to 'garbage'" do
      expect {
        api.interesting_photos(:date => 'garbage')
      }.to raise_error(FlickRaw::FailedResponse)
    end
  end
end


shared_examples_for "stub for Api.commons_institutions" do
  it "returns CommonsInstitutions object with no options" do
    
  end

end

shared_examples_for "flickr api stub that requires :photo_id key in options hash" do
  it "raises FlickRaw::FailedResponse when :photo_id not supplied in Hash" do
    expect {
      api.send(method,{})
    }.to raise_error(FlickRaw::FailedResponse)
  end
  it "raises FlickRaw::FailedResponse when :photo_id is nil" do
    expect {
      api.send(method,{:photo_id => nil})
    }.to raise_error(FlickRaw::FailedResponse)
  end
  it "raises FlickRaw::FailedResponse when :photo_id is garbage" do
    expect {
      api.send(method,{:photo_id => 'garbage'})
    }.to raise_error(FlickRaw::FailedResponse)
  end
end


