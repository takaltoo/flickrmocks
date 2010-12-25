shared_examples_for "page hash option" do
   let(:default_page){FlickrMocks::Api.default(:page)}
  def expected?
    begin
      expected
      true
    rescue
      false
    end
  end
   it "returns supplied page when valid page is provided" do
    subject.send(method,options.clone.merge(:page => '4')).should ==
      (expected? ? expected.clone.merge(:page => '4') : '4')
  end
  it "returns default page when 0 provided" do
    subject.send(method,options.clone.merge(:page => '0')).should ==
      (expected? ? expected.clone.merge(:page => default_page) : default_page)
  end
  it "returns default page when negative page provided" do
    subject.send(method,options.clone.merge(:page => '-1')).should ==
      (expected? ? expected.clone.merge(:page => default_page) : default_page)
  end
end
