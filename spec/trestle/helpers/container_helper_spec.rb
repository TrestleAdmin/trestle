require 'spec_helper'

require_relative '../../../app/helpers/trestle/container_helper'

describe Trestle::ContainerHelper do
  include Trestle::ContainerHelper

  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Context

  describe "#container" do
    it "captures the block and renders within .main-content-container > .main-content divs" do
      result = container { "Main content" }

      expect(result).to have_tag("div.main-content-container") do
        with_tag "div.main-content", text: "Main content"
      end
    end

    it "applies any additional attributes to the .main-content-container <div> tag (merging classes)" do
      result = container(id: "mycontainer", class: "mycontainer-class")
      expect(result).to have_tag("div#mycontainer.main-content-container.mycontainer-class")
    end

    context "with a sidebar" do
      it "yields a capture block to provide sidebar content" do
        result = container do |c|
          c.sidebar { "Sidebar" }
          "Main content"
        end

        expect(result).to have_tag("div.main-content-container") do
          with_tag "div.main-content", text: "Main content"
          with_tag "aside.main-content-sidebar", text: "Sidebar"
        end
      end

      it "applies any additional attributes on the .main-content-sidebar <aside> tag (merging classes)" do
        result = container do |c|
          c.sidebar(id: "mysidebar", class: "mysidebar-class") { "Sidebar" }
          "Main content"
        end

        expect(result).to have_tag("div.main-content-container") do
          with_tag "aside#mysidebar.main-content-sidebar.mysidebar-class"
        end
      end
    end
  end
end
