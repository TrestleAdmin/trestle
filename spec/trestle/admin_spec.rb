require 'spec_helper'

describe Trestle::Admin, remove_const: true do
  subject!(:admin) do
    Trestle.admin(:test)
  end

  before(:each) do
    Rails.application.reload_routes!
  end

  it "has an admin name" do
    expect(admin.admin_name).to eq("test")
  end

  it "has a route name" do
    expect(admin.route_name).to eq("test_admin")
  end

  it "has a parameter name" do
    expect(admin.parameter_name).to eq("test")
  end

  it "has a default view path" do
    expect(admin.view_path).to eq("admin/test")
  end

  it "allows a custom view path to be specified" do
    admin.view_path = "admin/custom"
    expect(admin.view_path).to eq("admin/custom")
  end

  it "has a controller namespace" do
    expect(admin.controller_namespace).to eq("test_admin/admin")
  end

  it "has a menu accessor" do
    block = Trestle::Navigation::Block.new

    admin.menu = block
    expect(admin.menu).to eq(block)
  end

  it "has an options accessor" do
    options = { option: "custom" }

    admin.options = options
    expect(admin.options).to eq(options)
  end

  context "breadcrumbs" do
    before(:each) do
      allow(I18n).to receive(:t).with(:"admin.test.name", default: [:"admin.name", "Test"]).and_return("Test Name")
      allow(I18n).to receive(:t).with(:"admin.breadcrumbs.test", default: "Test Name").and_return("Test Deprecated")
    end

    it "has a default breadcrumb" do
      expect(I18n).to receive(:t).with(:"admin.test.breadcrumbs.index", default: [:"admin.breadcrumbs.index", "Test Deprecated"]).and_return("Test Breadcrumb")
      expect(admin.default_breadcrumb).to eq(Trestle::Breadcrumb.new("Test Breadcrumb", "/admin/test"))
    end

    it "has a breadcrumb trail" do
      expect(I18n).to receive(:t).with(:"admin.breadcrumbs.home", default: "Home").and_return("Home")
      expect(I18n).to receive(:t).with(:"admin.test.breadcrumbs.index", default: [:"admin.breadcrumbs.index", "Test Deprecated"]).and_return("Test Breadcrumb")

      trail = Trestle::Breadcrumb::Trail.new([
        Trestle::Breadcrumb.new("Home", "/admin"),
        Trestle::Breadcrumb.new("Test Breadcrumb", "/admin/test")
      ])

      expect(admin.breadcrumbs).to eq(trail)
    end
  end

  it "has a set of hooks" do
    expect(admin.hooks).to eq(Trestle::Hook::Set.new)
  end

  describe "#path" do
    it "returns the path for the given action" do
      expect(admin.path(:index, foo: "bar")).to eq("/admin/test?foo=bar")
    end
  end

  describe "#translate" do
    it "translates the given key using sensible defaults" do
      expect(I18n).to receive(:t).with(:"admin.test.titles.index", default: [:"admin.titles.index", "Index"]).and_return("Test Index")
      expect(admin.translate("titles.index", default: "Index")).to eq("Test Index")
    end
  end

  describe "#to_param" do
    it "raises a NoMethodError if mistakenly called on the instance" do
      expect {
        admin.new(nil).to_param(123)
      }.to raise_error(NoMethodError, "#to_param called on non-resourceful admin. You may need to explicitly specify the admin.")
    end

    it "raises a NoMethodError if mistakenly called on the class" do
      expect {
        admin.to_param(123)
      }.to raise_error(NoMethodError, "#to_param called on non-resourceful admin. You may need to explicitly specify the admin.")
    end
  end

  context "scoped within a module" do
    subject!(:admin) do
      module Scoped; end
      Trestle.admin(:test, scope: Scoped)
    end

    it "has a scoped admin name" do
      expect(admin.admin_name).to eq("scoped/test")
    end

    it "has a prefixed route name" do
      expect(admin.route_name).to eq("scoped_test_admin")
    end

    it "has a scoped view path" do
      expect(admin.view_path).to eq("admin/scoped/test")
    end

    it "has a scoped controller namespace" do
      expect(admin.controller_namespace).to eq("scoped/test_admin/admin")
    end

    it "has an unscoped parameter name" do
      expect(admin.parameter_name).to eq("test")
    end

    it "has a default breadcrumb" do
      expect(I18n).to receive(:t).with(:"admin.scoped/test.name", default: [:"admin.name", "Test"]).and_return("Test Name")
      expect(I18n).to receive(:t).with(:"admin.breadcrumbs.scoped/test", default: "Test Name").and_return("Test Deprecated")
      expect(I18n).to receive(:t).with(:"admin.scoped/test.breadcrumbs.index", default: [:"admin.breadcrumbs.index", "Test Deprecated"]).and_return("Test")

      expect(admin.default_breadcrumb).to eq(Trestle::Breadcrumb.new("Test", "/admin/scoped/test"))
    end
  end
end
