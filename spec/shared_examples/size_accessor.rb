shared_examples_for "object with size accessor" do
  it "returns object with expected size" do
    subject.send(size).size.should == size
  end

  it "returns object with expected width" do
    subject.send(size).width.should == width
  end

  it "returns object with expected height" do
    subject.send(size).height.should == height
  end
end
