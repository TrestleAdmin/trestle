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

  it "converts to JSON representation" do
    configurable.option :myoption
    config.myoption = "test"

    expect(config.as_json({})).to eq({ myoption: "test" })
  end

  it "lazily initializes default values" do
    configurable.option :first, "first"
    expect(config.first).to eq("first")

    configurable.option :second, "second"
    expect(config.second).to eq("second")
  end

  describe "#configure" do
    it "yields itself" do
      expect { |b| config.configure(&b) }.to yield_with_args(config)
    end

    it "returns itself" do
      expect(config.configure).to eq(config)
    end
  end

  describe "#options" do
    it "returns a hash of defined options" do
      configurable.option :myoption
      config.myoption = "test"

      expect(config.options).to eq({ myoption: "test" })
    end
  end

  describe "#dup" do
    let(:original_options) { config.options }
    let(:duplicate) { config.dup }

    it "returns a new instance with a clone of the options" do
      expect(duplicate.options).to eq(original_options)
      expect(duplicate.options).not_to be(original_options)
    end
  end

  describe "#clone" do
    let(:original_options) { config.options }
    let(:duplicate) { config.clone }

    it "returns a new instance with a clone of the options" do
      expect(duplicate.options).to eq(original_options)
      expect(duplicate.options).not_to be(original_options)
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

    context "given a callable value" do
      it "calls the block when reading" do
        configurable.option :proc_option, -> { "test" }
        expect(config.proc_option).to eq("test")
      end

      it "returns the block if options[:evaluate] = false" do
        b = -> { "test" }
        configurable.option :proc_option, b, evaluate: false
        expect(config.proc_option).to eq(b)
      end
    end
  end

  describe ".deprecated_option" do
    it "defines accessors which produce the given deprecation warning" do
      configurable.deprecated_option :deprecated, "deprecation message"

      expect(Trestle.deprecator).to receive(:warn).twice.with("deprecation message")

      config.deprecated
      config.deprecated = :setting
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

    it "converts to JSON representation" do
      config.first.second.third = "value"
      expect(config.as_json({})).to eq({ first: { second: { third: "value" } } })
    end

    describe "#dup" do
      it "creates clones of nested options" do
        config.first.second.third = "value"
        duplicate = config.dup

        expect(duplicate.second.options).to eq(config.second.options)
        expect(duplicate.second.options).not_to be(config.second.options)
      end
    end
  end
end
