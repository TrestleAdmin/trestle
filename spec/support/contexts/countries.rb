RSpec.shared_context "countries" do
  before(:all) do
    Country = Struct.new(:code, :name) do
      alias id code
    end

    Region = Struct.new(:name, :countries)
  end

  after(:all) do
    Object.send(:remove_const, :Country)
    Object.send(:remove_const, :Region)
  end

  let(:countries) do
    [
      Country.new("AUS", "Australia"),
      Country.new("USA", "United States"),
      Country.new("NZ", "New Zealand")
    ]
  end

  let(:regions) do
    [
      Region.new("America", [Country.new("USA", "United States")]),
      Region.new("Oceania", [Country.new("AUS", "Australia"), Country.new("NZ", "New Zealand")]),
    ]
  end
end
