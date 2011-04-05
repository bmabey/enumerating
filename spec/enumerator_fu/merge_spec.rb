require "spec_helper"
require "enumerator_fu/merge"

describe EnumerableFu::Merge do

  include EnumerableFu

  context "without a block" do

    before do
      @array1 = [1,3,6]
      @array2 = [2,4,7]
      @array3 = [5,8]
      @merge = Merge.new([@array1, @array2, @array3].map(&:to_enum))
    end

    it "merges multiple Enumerators" do
      @merge.to_a.should == [1,2,3,4,5,6,7,8]
    end

  end

  context "with a block" do

    before do
      @array1 = %w(cccc dd a)
      @array2 = %w(eeeee bbb)
      @merge = Merge.new([@array1, @array2]) { |s| -s.length }
    end

    it "uses the block to determine order" do
      @merge.to_a.should == %w(eeeee cccc bbb dd a)
    end

  end

  it "is lazy" do
    @enum1 = [1,3]
    @enum2 = FailingEnumerable.new([2,4])
    @merge = Merge.new([@enum1, @enum2].map(&:to_enum))
    @merge.take(4).should == [1,2,3,4]
    lambda do
      @merge.take(5)
    end.should raise_error
  end

end