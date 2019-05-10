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

  let(:options) { {} }

  let(:block) do
    ->(d) {
      d.header "Header"
      d.link "Link", "#"
      d.divider
    }
  end

  it "renders the button within a button group" do
    expect(subject.to_s).to have_tag(".btn-group", with: { role: "group" }) do
      with_tag "#{tag}.btn.btn-default"
    end
  end

  it "renders the block items within a dropdown menu" do
    expect(subject.to_s).to have_tag(".btn-group", with: { role: "group" }) do
      with_tag "li.dropdown-header", text: "Header", with: { role: "presentation" }
      with_tag "li", with: { role: "presentation" } do
        with_tag "a", text: "Link", with: { href: "#", class: "dropdown-item" }
      end
      with_tag "li.divider", with: { role: "presentation" }
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
      with_tag "button.btn.btn-default.dropdown-toggle", with: { type: "button", "data-toggle": "dropdown" } do
        with_tag "span.caret"
        with_tag "span.sr-only", text: "Toggle dropdown"
      end
    end
  end
end

describe Trestle::Toolbar::Button do
  subject(:button) { Trestle::Toolbar::Button.new(template, "Label", options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "button", type: "submit"
  it_should_behave_like "a toolbar item with a split dropdown", "button", type: "submit"
end

describe Trestle::Toolbar::Link do
  subject(:link) { Trestle::Toolbar::Link.new(template, "Label", "#", options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "a", href: "#"
  it_should_behave_like "a toolbar item with a split dropdown", "a", href: "#"
end

describe Trestle::Toolbar::Dropdown do
  subject(:dropdown) { Trestle::Toolbar::Dropdown.new(template, "Label", options, &block) }

  let(:options) { {} }
  let(:block) { nil }

  it_should_behave_like "a toolbar item", "button.dropdown-toggle", type: "button", "data-toggle": "dropdown"
  it_should_behave_like "a toolbar item with a dropdown", "button.dropdown-toggle", type: "button", "data-toggle": "dropdown"

  include_context "template"

  it "renders a caret within the button label" do
    expect(subject.to_s).to have_tag("button") do
      with_tag("span.caret")
    end
  end
end
