require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:filter, :select, :find_all, :keep_if].each do |method|
    describe "##{method}" do
      let(:original) { Hamster.hash("A" => "aye", "B" => "bee", "C" => "see") }

      context "when everything matches" do
        it "returns self" do
          original.send(method) { |key, value| true }.should equal(original)
        end
      end

      context "when only some things match" do
        context "with a block" do
          let(:result) { original.send(method) { |key, value| key == "A" && value == "aye" }}

          it "preserves the original" do
            original.should eql(Hamster.hash("A" => "aye", "B" => "bee", "C" => "see"))
          end

          it "returns a set with the matching values" do
            result.should eql(Hamster.hash("A" => "aye"))
          end
        end

        it "yields entries as [key, value] pairs" do
          original.send(method) { |e| e.should be_kind_of(Array); ["A", "B", "C"].should include(e[0]); ["aye", "bee", "see"].should include(e[1]) }
        end

        context "with no block" do
          it "returns an Enumerator" do
            original.send(method).class.should be(Enumerator)
            original.send(method).to_a.sort.should == [['A', 'aye'], ['B', 'bee'], ['C', 'see']]
          end
        end
      end

      it "works on a large hash, with many combinations of input" do
        keys = (1..1000).to_a
        original = Hamster::Hash.new(keys.zip(2..1001))
        25.times do
          threshold = rand(1000)
          result    = original.send(method) { |k,v| k <= threshold }
          result.size.should == threshold
          result.each_key { |k| k.should <= threshold }
          (threshold+1).upto(1000) { |k| result.key?(k).should == false }
        end
      end
    end
  end
end