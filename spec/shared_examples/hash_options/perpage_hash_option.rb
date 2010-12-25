shared_examples_for "per page hash option" do
  let(:default_per_page){FlickrMocks::Api.default(:per_page)}
  def expected?
    begin
      expected
      true
    rescue
      false
    end
  end
  it "returns supplied per_page when valid per page is provided" do
    subject.send(method,options.clone.merge(:per_page => '400')).should ==
      (expected? ? expected.clone.merge(:per_page => '400') : '400')
  end
  it "returns supplied perpage when valid value is provided" do
    subject.send(method,options.clone.merge({:perpage => '400'})).should ==
      (expected? ? expected.clone.merge(:per_page => '400') : '400')
  end
  it "should give preference to supplied per_page value over :perpage" do
    subject.send(method,options.clone.merge({:per_page => '500', :perpage => '444'})).should ==
      (expected? ? expected.clone.merge(:per_page => '500') : '500')
  end
  it "returns default :per_page when supplied value is 0" do
    subject.send(method,options.clone.merge({:per_page => '0'})).should ==
      (expected? ? expected.clone.merge(:per_page => default_per_page) : default_per_page)
  end
  it "returns default :per_page when supplied value is negative" do
    subject.send(method,options.clone.merge({:per_page => '-1'})).should ==
      (expected? ? expected.clone.merge(:per_page => default_per_page) : default_per_page)
  end
  it "returns default :per_page when supplied :perpage is 0" do
    subject.send(method,options.clone.merge({:perpage => '0'})).should ==
      (expected? ? expected.clone.merge(:per_page => default_per_page) : default_per_page)
  end
  it "returns default :per_page when supplied :perpage is negative" do
    subject.send(method,options.clone.merge({:perpage=>'-1'})).should ==
      (expected? ? expected.clone.merge(:per_page => default_per_page) :default_per_page)
  end
  it "returns default :per_page when invalid :per_page and valid :perpage provided" do
    subject.send(method,options.clone.merge({:per_page => '-1', :perpage => '300'})).should ==
      (expected? ? expected.clone.merge(:per_page => default_per_page) : default_per_page)
  end
end
