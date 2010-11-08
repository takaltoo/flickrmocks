# subject is object under test
# reference is an object that responds to: :current_page,:per_page,:total_entries,:collection
shared_examples_for "object that responds to collection" do
  specify {subject.collection.class.should == WillPaginate::Collection}
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

shared_examples_for "object with no items that responds to collection" do
    specify {subject.should respond_to(:collection)}
    it "returns object with expected current_page" do
      subject.collection.current_page.should == reference.current_page
    end
    it "returns object with expected per_page" do
      subject.collection.per_page.should == reference.per_page
    end
    it "returns object with expected total_entries" do
      subject.collection.total_entries.should == reference.total_entries
    end
    it "returns object with no elements" do
      subject.collection.should == reference.collection
    end
end

shared_examples_for "object that responds to collection with usable option" do
    specify {subject.collection(true).class.should == WillPaginate::Collection}
    it "returns collection that includes only usable photos" do
      subject.collection(true).should == reference.collection
    end
    it "returns object with current_page set to 1" do
      subject.collection(true).current_page.should == reference.current_page
    end
    it "returns object with total_entries set to number of usable entries in current page" do
      subject.collection(true).total_entries.should == reference.total_entries
    end
    it "returns object with per_page set ot number of usable entries on current page" do
      subject.collection(true).per_page.should == reference.per_page
    end
end
