require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#each" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.each { }
      end

    end

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
        end

        describe "with a block" do

          before do
            @items = []
            @result = @original.each { |value| @items << value }
          end

          it "iterates over the items in order" do
            @items.should == values
          end

          it "returns nil" do
            @result.should be_nil
          end

        end

        describe "without a block" do

          before do
            @result = @original.each
          end

          it "returns self" do
            @result.should equal(@original)
          end

        end

      end

    end

  end

end
