require 'spec_helper'

describe Trestle::Configurable do
  subject(:configurable) do
    Class.new do
      include Trestle::Configurable
    end
  end

  subject(:config) { configurable.new }

  it "inspects neatly when class is named" do
    allow(configurable).to receive(:name).and_return("MyConfigurable")
    expect(config.inspect).to eq("#<MyConfigurable>")
  end

  it "inspects neatly when anonymous" do
    expect(config.inspect).to eq("#<Anonymous(Trestle::Configurable)>")
  end

  describe "#configure" do
    it "yields itself" do
      expect { |b| config.configure(&b) }.to yield_with_args(config)
    end

    it "returns itself" do
      expect(config.configure).to eq(config)
    end
  end

  describe ".option" do
    it "defines accessors for the option" do
      configurable.option :myoption

      config.myoption = "test"
      expect(config.myoption).to eq("test")
    end

    it "can be declared with a default value" do
      configurable.option :myoption_with_default, "default"

      expect(config.myoption_with_default).to eq("default")
    end
  end

  describe Trestle::Configurable::Open do
    subject(:configurable) do
      Class.new do
        include Trestle::Configurable
        include Trestle::Configurable::Open
      end
    end

    it "sets options arbitrarily" do
      config.automatic = "auto"
      expect(config.automatic).to eq("auto")
    end

    it "returns a new instance of itself if an option is not set" do
      expect(config.unset.nested.deeply).to be_a(configurable)
    end
  end
end
