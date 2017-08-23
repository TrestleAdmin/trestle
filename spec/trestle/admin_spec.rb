require 'spec_helper'

describe Trestle::Admin do
  before(:each) do
    class TestAdmin < Trestle::Admin; end
  end

  after(:each) do
    Object.send(:remove_const, :TestAdmin)
  end

  subject(:admin) { TestAdmin }

  it "has an admin name" do
    expect(admin.admin_name).to eq("test")
  end

  it "has a route name" do
    expect(admin.route_name).to eq("test_admin")
  end

  it "has a controller path" do
    expect(admin.controller_path).to eq("admin/test")
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

  it "has a breadcrumb trail" do
    trail = Trestle::Breadcrumb::Trail.new([
      Trestle::Breadcrumb.new("Home", "/admin"),
      Trestle::Breadcrumb.new("Test", "/admin/test")
    ])

    expect(admin.breadcrumbs).to eq(trail)
  end

  context "scoped within a module" do
    before(:each) do
      module Scoped
        class TestAdmin < Trestle::Admin; end
      end
    end

    after(:each) do
      Scoped.send(:remove_const, :TestAdmin)
    end

    subject(:admin) { Scoped::TestAdmin }

    it "has an admin name" do
      expect(admin.admin_name).to eq("scoped/test")
    end

    it "has a route name" do
      expect(admin.route_name).to eq("scoped_test_admin")
    end

    it "has a controller path" do
      expect(admin.controller_path).to eq("admin/scoped/test")
    end

    it "has a controller namespace" do
      expect(admin.controller_namespace).to eq("scoped/test_admin/admin")
    end
  end
end
