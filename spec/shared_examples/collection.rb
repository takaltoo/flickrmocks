# subject is object under test
# reference is an object that responds to: :current_page,:per_page,:total_entries,:collection
shared_examples_for "object that responds to collection" do
  specify{subject.collection.should be_a(WillPaginate::Collection)}
  it "returns object with expected current_page" do
    subject.collection.current_page.should == reference.current_page
  end
  it "returns object with expected per_page" do
    subject.collection.per_page.should == reference.per_page
  end
  it "returns object with expected total_entries" do
    subject.collection.total_entries.should == reference.total_entries
  end
  it "returns object with expected elements" do
    subject.collection.map do |item| item end.should == reference.collection.map do |item|  item end
  end
end
