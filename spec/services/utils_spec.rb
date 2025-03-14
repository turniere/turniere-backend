# frozen_string_literal: true

RSpec.describe Utils do
  [
    { test: 5, result: 4 },
    { test: 3, result: 2 },
    { test: 13, result: 8 },
    { test: 35, result: 32 },
    { test: 32, result: 32 },
    { test: 0, result: 0 },
    { test: 3482, result: 2048 },
    { test: 1337, result: 1024 }
  ].each do |parameters|
    it "calculates #{parameters[:result]} as previous power of two from #{parameters[:test]}" do
      expect(Utils.previous_power_of_two(parameters[:test])).to eq(parameters[:result])
    end
  end

  [
    { test: 5, result: 8 },
    { test: 3, result: 4 },
    { test: 13, result: 16 },
    { test: 35, result: 64 },
    { test: 32, result: 64 },
    { test: 0, result: 1 },
    { test: 3482, result: 4096 },
    { test: 1337, result: 2048 }
  ].each do |parameters|
    it "calculates #{parameters[:result]} as previous power of two from #{parameters[:test]}" do
      expect(Utils.next_power_of_two(parameters[:test])).to eq(parameters[:result])
    end
  end

  [
    { test: 5, result: false },
    { test: 3, result: false },
    { test: 16, result: true },
    { test: 4, result: true },
    { test: 32, result: true },
    { test: 0, result: false },
    { test: 3482, result: false },
    { test: 8192, result: true }
  ].each do |parameters|
    is_isnt = "isn't" unless parameters[:result]
    is_isnt = 'is' if parameters[:result]
    it "thinks #{parameters[:test]} #{is_isnt} a power of two" do
      expect(Utils.po2?(parameters[:test])).to eq(parameters[:result])
    end
  end

  describe '#split_and_rotate' do
    [
      { test: [1, 2, 3, 4, 5, 6], result: [4, 5, 6, 1, 2, 3] },
      { test: [1, 2, 3, 4, 5], result: [3, 4, 5, 1, 2] },
      { test: [1, 2, 3, 4], result: [3, 4, 1, 2] },
      { test: [1, 2, 3], result: [2, 3, 1] },
      { test: [1, 2], result: [2, 1] },
      { test: [1], result: [1] },
      { test: [], result: [] }
    ].each do |parameters|
      it "splits and rotates #{parameters[:test]} to #{parameters[:result]}" do
        expect(Utils.split_and_rotate(parameters[:test])).to eq(parameters[:result])
      end
    end
  end
end
