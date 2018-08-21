require 'spec_helper'

describe Trestle::Toolbar do
  subject(:toolbar) { Trestle::Toolbar.new }

  let(:template) { ActionView::Base.new }

  let(:button) { double}
  let(:link) { double }

  before(:each) do
    allow(template).to receive(:button_tag).and_return(button)
    allow(template).to receive(:admin_link_to).and_return(link)
    allow(template).to receive(:icon) { |klass| template.content_tag(:i, "", class: klass) }
  end

  it "initially has no groups" do
    expect(toolbar.groups(template).to_a).to be_empty
  end

  describe "#append" do
    it "appends buttons and links defined in the block" do
      toolbar.append do |t|
        t.button "Button"
      end

      toolbar.append do |t|
        t.link "Link", "#"
      end

      expect(toolbar.groups(template).to_a).to eq [[button], [link]]
    end

    it "allows organization of buttons and links into groups" do
      toolbar.append do |t|
        t.group do
          t.button "Button"
          t.link "Link", "#"
        end
      end

      expect(toolbar.groups(template).to_a).to eq [[button, link]]
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

      expect(toolbar.groups(template).to_a).to eq [[link], [button]]
    end
  end

  describe Trestle::Toolbar::Builder do
    let(:builder) { Trestle::Toolbar::Builder.new(template) }

    describe "#button" do
      it "creates a button tag" do
        expect(template).to receive(:button_tag).with('<span class="btn-label">Button</span>', class: %w(btn btn-default)).and_return(button)
        expect(builder.button("Button")).to eq(button)
      end

      it "allows the button style to be specified" do
        expect(template).to receive(:button_tag).with('<span class="btn-label">Button</span>', class: %w(btn btn-success)).and_return(button)
        expect(builder.button("Button", style: :success)).to eq(button)
      end

      it "allows an icon to be specified" do
        expect(template).to receive(:button_tag).with('<i class="fa fa-trash"></i> <span class="btn-label">Button</span>', class: %w(btn btn-default)).and_return(button)
        expect(builder.button("Button", icon: "fa fa-trash")).to eq(button)
      end
    end

    describe "#link" do
      it "creates a button link" do
        expect(template).to receive(:admin_link_to).with('<span class="btn-label">Link</span>', "#", class: %w(btn btn-default)).and_return(link)
        expect(builder.link("Link", "#")).to eq(link)
      end

      it "allows the button style to be specified" do
        expect(template).to receive(:admin_link_to).with('<span class="btn-label">Link</span>', "#", class: %w(btn btn-success)).and_return(link)
        expect(builder.link("Link", "#", style: :success)).to eq(link)
      end

      it "allows an icon to be specified" do
        expect(template).to receive(:admin_link_to).with('<i class="fa fa-trash"></i> <span class="btn-label">Link</span>', "#", class: %w(btn btn-default)).and_return(link)
        expect(builder.link("Link", "#", icon: "fa fa-trash")).to eq(link)
      end
    end
  end
end
