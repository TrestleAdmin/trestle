require 'spec_helper'

describe Trestle::Navigation::Item do
  subject(:item) { Trestle::Navigation::Item.new(:test) }

  it "has a label based on the internationalized name" do
    expect(I18n).to receive(:t).with("admin.navigation.items.test", default: "Test").and_return("Test")
    expect(item.label).to eq("Test")
  end

  it "can override the label from options" do
    item = Trestle::Navigation::Item.new(:test, label: "Custom Label")
    expect(item.label).to eq("Custom Label")
  end

  it "has a default priority of 0" do
    expect(item.priority).to eq(0)
  end

  it "has a default group of NullGroup" do
    expect(item.group).to eq(Trestle::Navigation::NullGroup.new)
  end

  it "sets the group from options" do
    group = Trestle::Navigation::Group.new(:test)
    item = Trestle::Navigation::Item.new(:test, group: group)

    expect(item.group).to eq(group)
  end

  it "has a default icon" do
    expect(item.icon).to eq(Trestle.config.default_navigation_icon)
  end

  it "sets the icon from options" do
    item = Trestle::Navigation::Item.new(:test, icon: "fa fa-user")
    expect(item.icon).to eq("fa fa-user")
  end

  it "sets the path from parameters" do
    item = Trestle::Navigation::Item.new(:test, "/path")
    expect(item.path).to eq("/path")
  end

  context "passing admin via options" do
    let(:admin) { double }

    it "sets the path from the admin via options (using symbol)" do
      expect(admin).to receive(:path).with(nil).and_return("/admin")
      expect(Trestle).to receive(:lookup).with(:admin).and_return(admin)
      item = Trestle::Navigation::Item.new(:test, admin: :admin)
      expect(item.path).to eq("/admin")
    end

    it "sets the path from the admin and action via options (using symbol)" do
      expect(admin).to receive(:path).with(:show).and_return("/admin")
      expect(Trestle).to receive(:lookup).with(:admin).and_return(admin)
      item = Trestle::Navigation::Item.new(:test, admin: :admin, action: :show)
      expect(item.path).to eq("/admin")
    end

    it "sets the path from the admin via options (using class)" do
      expect(admin).to receive(:path).with(nil).and_return("/admin")
      item = Trestle::Navigation::Item.new(:test, admin: admin)
      expect(item.path).to eq("/admin")
    end

    it "raises an error if symbol admin via options can't be found" do
      expect(Trestle).to receive(:lookup).with(:missing).and_return(nil)
      item = Trestle::Navigation::Item.new(:test, admin: :missing)
      expect { item.path }.to raise_error(ActionController::UrlGenerationError, "No admin found named :missing")
    end
  end

  it "uses # as the fallback path if no path or admin provided" do
    item = Trestle::Navigation::Item.new(:test)
    expect(item.path).to eq("#")
  end

  it "sorts by priority" do
    i1 = Trestle::Navigation::Item.new(:test1)
    i2 = Trestle::Navigation::Item.new(:test2, priority: :first)
    i3 = Trestle::Navigation::Item.new(:test3, priority: :last)
    i4 = Trestle::Navigation::Item.new(:test4, priority: 50)

    expect([i1, i2, i3, i4].sort).to eq([i2, i1, i4, i3])
  end

  it "sorts by name if priority is equal" do
    i1 = Trestle::Navigation::Item.new(:test1, priority: 1)
    i2 = Trestle::Navigation::Item.new(:test2, priority: 1)
    i3 = Trestle::Navigation::Item.new(:test3, priority: 1)

    expect([i3, i1, i2].sort).to eq([i1, i2, i3])
  end

  it "sorts with string and symbol names" do
    i1 = Trestle::Navigation::Item.new(:test1)
    i2 = Trestle::Navigation::Item.new("test2")
    i3 = Trestle::Navigation::Item.new(:test3)

    expect([i3, i1, i2].sort).to eq([i1, i2, i3])
  end

  it "is visible by default" do
    expect(item.visible?(self)).to be true
  end

  it "is not visible if options[:if] is provided and evaluates to false" do
    item = Trestle::Navigation::Item.new(:test, if: -> { false })
    expect(item.visible?(self)).to be false
  end

  it "is not visible if options[:unless] if provided and evaluates to true" do
    item = Trestle::Navigation::Item.new(:test, unless: -> { true })
    expect(item.visible?(self)).to be false
  end

  it "can set html_options" do
    item = Trestle::Navigation::Item.new(:test, icon: "fa", class: "text-danger")
    expect(item.html_options).to eq({ class: "text-danger" })
  end

  context "with a badge" do
    it "has a badge" do
      item = Trestle::Navigation::Item.new(:test, badge: { text: "123", class: "badge-success" })

      expect(item.badge?).to be true
      expect(item.badge.text).to eq("123")
      expect(item.badge.html_class).to eq("badge-success")
    end

    it "has a badge with a default class if full options not provided" do
      item = Trestle::Navigation::Item.new(:test, badge: "123")

      expect(item.badge?).to be true
      expect(item.badge.text).to eq("123")
      expect(item.badge.html_class).to eq("badge-primary")
    end
  end
end
