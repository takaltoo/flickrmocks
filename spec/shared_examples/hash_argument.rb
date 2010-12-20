shared_examples_for "object that expects single Hash argument" do
  it "raises ArgumentError when no option provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end

  it "raises ArgumentError when nil provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end

  it "raises ArgumentError when [] provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end
  it "raises ArgumentError when FixNum provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end
  it "raises ArgumentError when string provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end
  it "raises ArgumentError when symbol provided" do
    expect {
      subject.send(method)
    }.to raise_error(ArgumentError)
  end
end
