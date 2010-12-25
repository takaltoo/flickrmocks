shared_examples_for "tag mode hash option" do
  let(:default_tag_mode){FlickrMocks::Api.default(:tag_mode)}
  def expected?
    begin
      expected
      true
    rescue
      false
    end
  end
  it "returns supplied value when :tag_mode is all" do
    subject.send(method,options.clone.merge({:tag_mode=>'all'})).should ==
      (expected? ? expected.clone.merge({:tag_mode => 'all'}) : 'all')
  end
  it "returns supplied value when :tag_mode is any" do
    subject.send(method,options.clone.merge({:tag_mode=>'any'})).should ==
      (expected? ? expected.clone.merge({:tag_mode => 'any'}) : 'any')
  end
  it "returns default tag_mode when tag_mode is not specified" do
    subject.send(method,options.clone.merge({})).should ==
      (expected? ? expected.clone.merge({:tag_mode => default_tag_mode}) : default_tag_mode)
  end
  it "returns default tag_mode when tag_mode is nil" do
    subject.send(method,options.clone.merge({:tag_mode => nil})).should ==
      (expected? ? expected.clone.merge({:tag_mode => default_tag_mode}) : default_tag_mode)
  end
  it "should give default tag_mode when junk given for tag_mode" do
    subject.send(method,options.clone.merge(:tag_mode => 'junk')).should ==
      (expected? ? expected.clone.merge({:tag_mode => default_tag_mode}) : default_tag_mode)
  end
end
