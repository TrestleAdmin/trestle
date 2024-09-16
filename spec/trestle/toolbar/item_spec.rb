require 'spec_helper'

shared_examples "a toolbar item" do |tag, attrs|
  include_context "template"

  let(:options) { {} }

  describe "default options" do
    it "renders a button with class btn-default" do
      expect(subject.to_s).to have_tag("#{tag}.btn.btn-default", with: attrs) do
        with_tag("span.btn-label", text: /Label/)
      end
    end
  end

  describe "with a custom style" do
    let(:options) { { style: :info } }

    it "renders the button with the given style class" do
      expect(subject.to_s).to have_tag("#{tag}.btn.btn-info", with: attrs)
    end
  end

  describe "with a custom class" do
    let(:options) { { class: "mybutton" } }

    it "appends the given class to the button style classes" do
      expect(subject.to_s).to have_tag("#{tag}.btn.btn-default.mybutton", with: attrs)
    end
  end

  describe "with an icon" do
    let(:options) { { icon: "fa fa-user" } }

    it "renders the button with an icon alongside the label" do
      expect(subject.to_s).to have_tag("#{tag}.btn.btn-default.has-icon", with: attrs) do
        with_tag("i.fa.fa-user")
        with_tag("span.btn-label", text: /Label/)
      end
    end
  end
end

shared_examples "a toolbar item with a dropdown" do |tag, attrs|
  include_context "template"

  let(:admin) { double(root_action: :index) }

  let(:options) { {} }

  let(:block) do
    ->(d) {
      d.header "Header"
      d.link "Link", "#"
      d.link "Disabled Link", class: "disabled", admin: :test
      d.divider
    }
  end

  before(:each) {
    allow(Trestle).to receive(:lookup).with(admin).and_return(admin)
    allow(Trestle).to receive(:lookup).with(:test).and_return(admin)
    allow(admin).to receive(:path).and_return("/admin/test")
  }

  it "renders the button within a button group" do
    expect(subject.to_s).to have_tag(".btn-group", with: { role: "group" }) do
      with_tag "#{tag}.btn.btn-default"
    end
  end

  it "renders the block items within a dropdown menu" do
    expect(subject.to_s).to have_tag(".btn-group", with: { role: "group" }) do
      with_tag "li" do
        with_tag "h6", text: "Header", with: { class: "dropdown-header" }
      end
      with_tag "li" do
        with_tag "a", text: "Link", with: { href: "#", class: "dropdown-item" }
      end
      with_tag "li" do
        with_tag "a", text: "Disabled Link", with: { href: "/admin/test", class: "disabled dropdown-item" }
      end
      with_tag "li" do
        with_tag "hr", class: "dropdown-divider"
      end
    end
  end
end

shared_examples "a toolbar item with a split dropdown" do |tag, attrs|
  include_context "template"

  let(:options) { {} }

  let(:block) do
    ->(d) {
      d.link "Link", "#"
    }
  end

  it_should_behave_like "a toolbar item with a dropdown", tag, attrs

  it "renders a dropdown toggle button" do
    expect(subject.to_s).to have_tag(".btn-group", with: { role: "group" }) do
      with_tag "button.btn.btn-default.dropdown-toggle.dropdown-toggle-split", with: { type: "button", "data-bs-toggle": "dropdown" } do
        with_tag "span.visually-hidden", text: "Toggle dropdown"
      end
    end
  end
end

describe Trestle::Toolbar::Button do
  subject(:button) { Trestle::Toolbar::Button.new(template, "Label", **options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "button", type: "submit"
  it_should_behave_like "a toolbar item with a split dropdown", "button", type: "submit"
end

describe Trestle::Toolbar::Link do
  subject(:link) { Trestle::Toolbar::Link.new(template, "Label", "#", **options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "a", href: "#"
  it_should_behave_like "a toolbar item with a split dropdown", "a", href: "#"
end

describe Trestle::Toolbar::Dropdown do
  subject(:dropdown) { Trestle::Toolbar::Dropdown.new(template, "Label", **options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "button.dropdown-toggle", type: "button", "data-bs-toggle": "dropdown"
  it_should_behave_like "a toolbar item with a dropdown", "button.dropdown-toggle", type: "button", "data-bs-toggle": "dropdown"

  include_context "template"
end
