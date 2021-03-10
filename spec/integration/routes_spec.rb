require 'spec_helper'

describe "Trestle::Admin routes", type: :routing, remove_const: true do
  routes { Trestle::Engine.routes }

  subject!(:admin) do
    Trestle.admin(:test)
  end

  before(:each) do
    Rails.application.reload_routes!
  end

  it "routes to the admin index action" do
    expect(get: "/test").to route_to({
      controller: "test_admin/admin",
      action:     "index"
    })
  end

  context "with a custom path" do
    subject!(:admin) do
      Trestle.admin(:test, path: "custom")
    end

    it "routes to the custom path" do
      expect(get: "/custom").to route_to({
        controller: "test_admin/admin",
        action:     "index"
      })
    end
  end

  context "with additional routes" do
    subject!(:admin) do
      Trestle.admin(:test) do
        routes do
          get :custom
        end
      end
    end

    it "routes additional routes within the controller/path scope" do
      expect(get: "/test/custom").to route_to({
        controller: "test_admin/admin",
        action:     "custom"
      })
    end
  end
end

describe "Trestle::Resource routes", type: :routing, remove_const: true do
  routes { Trestle::Engine.routes }

  let!(:model) { stub_const("Test", Class.new) }

  subject!(:admin) do
    Trestle.resource(:test)
  end

  before(:each) do
    Rails.application.reload_routes!
  end

  it "routes to the admin index action" do
    expect(get: "/test").to route_to({
      controller: "test_admin/admin",
      action:     "index"
    })
  end

  it "routes to the admin show action" do
    expect(get: "/test/123").to route_to({
      controller: "test_admin/admin",
      action:     "show",
      id:         "123"
    })
  end

  context "with a custom path" do
    subject!(:admin) do
      Trestle.resource(:test, path: "custom")
    end

    it "routes to the custom path" do
      expect(get: "/custom").to route_to({
        controller: "test_admin/admin",
        action:     "index"
      })
    end
  end

  context "with additional routes" do
    subject!(:admin) do
      Trestle.resource(:test) do
        routes do
          get :custom, on: :member
        end
      end
    end

    it "routes additional routes within the controller/path scope" do
      expect(get: "/test/123/custom").to route_to({
        controller: "test_admin/admin",
        action:     "custom",
        id:         "123"
      })
    end
  end
end
