shared_examples_for "object with Array accessor helpers" do

  specify{subject.should respond_to(:[])}
  specify{subject.should respond_to(:at)}
  specify{subject.should respond_to(:fetch)}
  specify{subject.should respond_to(:first)}
  specify{subject.should respond_to(:last)}
  specify{subject.should respond_to(:each)}
  specify{subject.should respond_to(:each_index)}
  specify{subject.should respond_to(:reverse_each)}
  specify{subject.should respond_to(:length)}
  specify{subject.should respond_to(:size)}
  specify{subject.should respond_to(:empty?)}
  specify{subject.should respond_to(:find_index)}
  specify{subject.should respond_to(:index)}
  specify{subject.should respond_to(:rindex)}
  specify{subject.should respond_to(:collect)}
  specify{subject.should respond_to(:map)}
  specify{subject.should respond_to(:select)}
  specify{subject.should respond_to(:keep_if)}
  specify{subject.should respond_to(:values_at)}

  context "#[]" do
    it "returns same reference for index 0" do
      subject[0].should == reference[0]
    end
    it "returns same reference for index -1" do
      subject[-1].should == reference[-1]
    end
  end

  context "#at" do
    it "returns same as reference element 0" do
      subject.at(0).should == reference.at(0)
    end
  end

  context "#values_at" do
    it "returns same value as element 0" do
      subject.values_at(0).should == reference.values_at(0)
    end
  end

  context "#fetch" do
    it "returns same as reference for element 0" do
      subject.fetch(0).should == reference.fetch(0)
    end
  end

  context "#first" do
    it "returns same element as reference" do
      subject.first == reference.first
    end
  end

  context "#last" do
    it "returns same element as reference" do
      subject.last == reference.last
    end
  end

  context "#length" do
    it "returns same value as reference" do
      subject.length.should == reference.length
    end
  end

  context "#size" do
    it "returns same value as reference" do
      subject.size.should == reference.size
    end
  end

  context "#find_index" do
    it "returns same index as reference" do
      subject.find_index(subject[0]).should == reference.find_index(subject[0])
    end
  end

  context "#index" do
    it "returns same index as reference" do
      subject.index(subject[0]).should == reference.index(subject[0])
    end
  end

  context "#empty?" do
    it "returns same value as reference" do
      subject.empty?.should == reference.empty?
    end
  end

  context "#each" do
    it "returns same list as reference" do
      actual = []
      expected =[]
      subject.each {|v| actual.push v}
      reference.each{|v| expected.push v}
      actual.should == expected
    end
  end


  context "#each_index" do
    it "returns same list as reference" do
      compare_iterator(:each_index)
    end
  end

  context "#reverse_each" do
    it "returns same list as reference" do
      compare_iterator(:reverse_each)
    end
  end

  context "#rindex" do
    it "returns same list as reference" do
      compare_iterator(:rindex)
    end
  end

  context "#select" do
    it "returns same list as reference" do
      actual = []
      expected = []
      subject.select {|v| true }.should == reference.select {|v| true }
    end
  end

  context "#collect" do
    it "returns same as reference" do
      subject.collect { |v| v }.should == reference.collect { |v| v }
    end
  end

  context "#map" do
    it "returns same as reference" do
      subject.map {|v| v.__id__ }.should == reference.map { |v| v.__id__ }
    end
  end

  context "#keep_if" do
    it "returns same as reference" do
      subject.keep_if {|v| true}.should == reference.keep_if {|v| true}
    end
  end

  private

  def compare_iterator(method)
    actual = []
    expected = []
    subject.send(method) {|v| actual.push(v) }.should ==  reference.send(method) { |v| expected.push(v) }
  end
end

