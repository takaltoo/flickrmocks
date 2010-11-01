shared_examples_for "object with flickr image url helpers" do
  let(:base_url){"http://farm#{photo_fixture['farm']}.static.flickr.com/#{photo_fixture['server']}/#{photo_fixture['id']}_#{photo_fixture['secret']}"}

  specify {subject.should respond_to(:square)}
  context "#square" do
    it "returns expected url for squre flickr image" do
      subject.square.should == "#{base_url}_s.jpg"
    end
  end

  specify {subject.should respond_to(:thumbnail)}
  context "#thumbnail_url" do
    it "returns expected url for thumbnail image" do
      subject.thumbnail.should == "#{base_url}_t.jpg"
    end
  end

  specify {subject.should respond_to(:small)}
  context "#small" do
    it "returns expected url for small image" do
      subject.small.should == "#{base_url}_m.jpg"
    end
  end

  specify {subject.should respond_to(:medium)}
  context "#medium" do
    it "returns expected url for medium" do
      subject.medium.should == "#{base_url}.jpg"
    end
  end

  specify {subject.should respond_to(:large)}
  context "#large" do
    it "returns expected url for large image" do
      subject.large.should == "#{base_url}_b.jpg"
    end
  end

  specify {subject.should respond_to(:medium_640)}
  context "#medium_640" do
    it "returns expected url for medium 640 image" do
      subject.medium_640.should == "#{base_url}_z.jpg"
    end
  end

  specify {subject.should respond_to(:'medium 640')}
  context "#'medium 640'" do
    it "returns expected url for medium 640 image" do
      subject.send(:'medium 640').should == "#{base_url}_z.jpg"
    end
  end
end
