shared_examples_for "date hash option" do
  def expected?
    begin
      expected
      true
    rescue
      false
    end
  end
  let(:default_date){FlickrMocks::Api::Helpers.date}

        def self.date(params=nil)
        case params
        when String then Api::Helpers.date(params)
        when Time then params.strftime('%Y-%m-%d')
        else Api::Helpers.date('yesterday')
        end
      end
  
  it "returns date when proper date string supplied" do
    subject.send(method,options.clone.merge(:date => '2010-10-10')).should ==
      (expected? ? expected.clone.merge(:date => '2010-10-10') : '2010-10-10')
  end
  it "returns default date when :date is nil" do
    subject.send(method,options.clone.merge(:date => nil)).should ==
      (expected? ? expected.clone.merge(:date => default_date) : default_date)
  end
  it "returns default date when :date is not set" do
    subject.send(method,options.clone.merge({})).should ==
      (expected? ? expected.clone.merge(:date => default_date) : default_date)
  end
  it "returns default date when Time object provided" do
    time ='2010-01-01'
    subject.send(method,options.clone.merge(:date=>Time.new(time))).should ==
      (expected? ? expected.clone.merge(:date => time) : time)
  end
  it "returns yesterday when Array object provided" do
    subject.send(method,options.clone.merge(:date => [])).should ==
      (expected? ? expected.clone.merge(:date => default_date) : default_date)
  end

end
