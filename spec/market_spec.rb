require "spec_helper"

describe Market do
  before do
    @test_cases = []
    @test_cases << { items: ["CH1", "AP1"], expected: 9.11 }
    @test_cases << { items: ["CH1", "AP1", "AP1", "AP1", "MK1"], expected: 16.61 }
    @test_cases << { items: ["CH1", "AP1", "CF1", "MK1"], expected: 20.34 }
    @test_cases << { items: ["MK1", "AP1"], expected: 10.75 }
    @test_cases << { items: ["CF1", "CF1"], expected: 11.23 }
    @test_cases << { items: ["AP1", "AP1", "CH1", "AP1"], expected: 16.61 }
  end

  it "has a version number" do
    expect(Market::VERSION).not_to be nil
  end

  it "applies item price and discounts" do
    @test_cases.each do |test_data|
      co = Market::Checkout.new

      test_data[:items].each do |item|
        co.scan(item)
      end

      expect(co.total).to eq test_data[:expected]
    end
  end

  it "should raise an exception on an invalid item" do
    co = Market::Checkout.new
    expect { co.scan("DOOD") }.to raise_error(Market::UnknownTransactionError)
  end
end
