require 'spec_helper'

describe Trestle::Configuration do
  subject(:config) { Trestle::Configuration.new }

  it "has a site title configuration option" do
    expect(config).to have_accessor(:site_title).with_default("Trestle Admin")
  end

  it "has a footer configuration option" do
    expect(config).to have_accessor(:footer).with_default("Powered by Trestle")
  end

  it "has site logo configuration options" do
    expect(config).to have_accessor(:site_logo)
    expect(config).to have_accessor(:site_logo_small)
  end

  it "has a favicon configuration option" do
    expect(config).to have_accessor(:favicon)
  end

  it "has a timestamp precision configuration option" do
    expect(config).to have_accessor(:timestamp_precision).with_default(:minutes)
  end

  it "has a path configuration option" do
    expect(config).to have_accessor(:path).with_default("/admin")
  end

  it "has a root configuration option" do
    expect(config).to have_accessor(:root).with_default("/admin")
  end

  it "has an automount configuration option" do
    expect(config).to have_accessor(:automount).with_default(true)
  end

  it "has a Turbolinks configuration option" do
    expect(config).to have_accessor(:turbolinks).with_default(false)
  end

  it "has a display methods configuration option" do
    expect(config).to have_accessor(:display_methods).with_default([:display_name, :full_name, :name, :title, :username, :login, :email])
  end

  it "has a persistent params configuration option" do
    expect(config).to have_accessor(:persistent_params).with_default([:sort, :order, :scope])
  end

  it "has a default navigation icon configuration option" do
    expect(config).to have_accessor(:default_navigation_icon).with_default("fa fa-arrow-circle-o-right")
  end

  it "has a default adapter configuration option" do
    expect(config).to have_accessor(:default_adapter)

    expect(config.default_adapter).to be < Trestle::Adapters::Adapter
    expect(config.default_adapter.ancestors).to include(Trestle::Adapters::ActiveRecordAdapter, Trestle::Adapters::DraperAdapter)
  end

  it "has a root breadcrumbs configuration option" do
    expect(config).to have_accessor(:root_breadcrumbs).with_default([Trestle::Breadcrumb.new("Home", "/admin")])
  end

  it "has a debug form errors configuration option" do
    expect(config).to have_accessor(:debug_form_errors).with_default(false)
  end

  it "has no default menu blocks" do
    expect(config.menus).to eq([])
  end

  describe "#menu" do
    it "adds an unbound navigation block to menus" do
      b = proc {}
      config.menu &b

      block = config.menus.first
      expect(block).to be_a(Trestle::Navigation::Block)
      expect(block.block).to eq(b)
    end
  end

  it "has no default hooks" do
    expect(config.hooks).to be_empty
  end

  describe "#hook" do
    let(:block) { -> {} }

    it "adds a hook for the given name" do
      config.hook "myhook", &block

      expect(config.hooks.for("myhook")).to eq([Trestle::Hook.new("myhook", {}, &block)])
    end
  end

  it "has no default helpers" do
    expect(config.helpers).to eq([])
  end

  describe "#helper" do
    it "appends the given helpers" do
      config.helper :all
      expect(config.helpers).to eq([:all])
    end
  end

  describe "#form_field" do
    let(:klass) { double }

    it "registers a form field type" do
      expect(Trestle::Form::Builder).to receive(:register).with(:custom, klass)
      config.form_field :custom, klass
    end
  end

  it "has a list of load paths" do
    expect(config).to have_accessor(:load_paths)
    expect(config.load_paths).to be_an(Array)
  end

  it "has no default before actions" do
    expect(config.before_actions).to eq([])
  end

  it "has no default after actions" do
    expect(config.after_actions).to eq([])
  end

  it "has no default around actions" do
    expect(config.around_actions).to eq([])
  end

  describe "#before_action" do
    let(:options) { double }
    let(:block) { Proc.new {} }

    it "registers a before action" do
      config.before_action(options, &block)
      expect(config.before_actions).to eq([Trestle::Configuration::Action.new(options, block)])
    end
  end

  describe "#after_action" do
    let(:options) { double }
    let(:block) { Proc.new {} }

    it "registers an afer action" do
      config.after_action(options, &block)
      expect(config.after_actions).to eq([Trestle::Configuration::Action.new(options, block)])
    end
  end

  describe "#around_action" do
    let(:options) { double }
    let(:block) { Proc.new {} }

    it "registers an around action" do
      config.around_action(options, &block)
      expect(config.around_actions).to eq([Trestle::Configuration::Action.new(options, block)])
    end
  end
end
