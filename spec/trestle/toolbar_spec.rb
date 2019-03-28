require 'spec_helper'

describe Trestle::Toolbar do
  include_context "template"

  subject(:toolbar) { Trestle::Toolbar.new }

  before(:each) do
    template.extend(Trestle::UrlHelper)
  end

  it "initially has no groups" do
    expect(toolbar.groups(template).to_a).to be_empty
  end

  describe "#clear!" do
    before(:each) do
      toolbar.append do |t|
        t.button "Button"
      end
    end

    it "clears out any defined blocks" do
      toolbar.clear!
      expect(toolbar.groups(template).to_a).to be_empty
    end
  end

  describe "#append" do
    it "appends buttons, links and dropdowns defined in the block" do
      toolbar.append do |t|
        t.button "Button"
      end

      toolbar.append do |t|
        t.link "Link", "#"
        t.dropdown "Dropdown"
      end

      expect(toolbar.groups(template).to_a).to eq [
        [Trestle::Toolbar::Button.new(template, "Button")],
        [Trestle::Toolbar::Link.new(template, "Link", "#")],
        [Trestle::Toolbar::Dropdown.new(template, "Dropdown")]
      ]
    end

    it "allows organization of buttons and links into groups" do
      toolbar.append do |t|
        t.group do
          t.button "Button"
          t.link "Link", "#"
        end
      end

      expect(toolbar.groups(template).to_a).to eq [
        [Trestle::Toolbar::Button.new(template, "Button"), Trestle::Toolbar::Link.new(template, "Link", "#")]
      ]
    end
  end

  describe "#prepend" do
    it "prepends buttons and links defined in the block" do
      toolbar.prepend do |t|
        t.button "Button"
      end

      toolbar.prepend do |t|
        t.link "Link", "#"
      end

      expect(toolbar.groups(template).to_a).to eq [
        [Trestle::Toolbar::Link.new(template, "Link", "#")],
        [Trestle::Toolbar::Button.new(template, "Button")]
      ]
    end
  end

  describe Trestle::Toolbar::Builder do
    let(:builder) { Trestle::Toolbar::Builder.new(template) }

    it "has a list of registered builder methods" do
      expect(builder.builder_methods).to include(:button, :link, :dropdown)
    end

    describe "#button" do
      it "creates a Button instance" do
        expect(builder.button("Button Label", style: :success)).to eq(Trestle::Toolbar::Button.new(template, "Button Label", style: :success))
      end
    end

    describe "#link" do
      it "creates a Link instance" do
        expect(builder.link("Link Label", "#", style: :info)).to eq(Trestle::Toolbar::Link.new(template, "Link Label", "#", style: :info))
      end
    end

    describe "#dropdown" do
      it "creates a Dropdown instance" do
        expect(builder.dropdown("Dropdown Label")).to eq(Trestle::Toolbar::Dropdown.new(template, "Dropdown Label"))
      end
    end
  end
end
