require 'spec_helper'

describe Trestle::Table::Column do
  let(:options) { {} }
  let(:template) { double }
  let(:table) { Trestle::Table.new }

  subject(:column) do
    Trestle::Table::Column.new(table, :my_field, options) { |instance| instance }
  end

  describe "#header" do
    let(:options) { { header: "Custom Header" } }

    it "returns the header based on the internationalized field name" do
      expect(I18n).to receive(:t).with("admin.table.header.my_field", default: "Custom Header").and_return("Custom Header")
      expect(column.header(template)).to eq("Custom Header")
    end
  end

  describe "#classes" do
    let(:options) { { class: "custom-class", align: :center } }

    it "returns classes specified in options" do
      expect(column.classes).to include("custom-class")
    end

    it "returns an alignment class" do
      expect(column.classes).to include("text-center")
    end
  end

  describe "#data" do
    let(:options) { { data: { attr: "custom" } } }

    it "returns data specified in options" do
      expect(column.data).to eq({ attr: "custom" })
    end
  end

  context "with a block" do
    describe "#content" do
      let(:instance) { double }

      it "returns the result of the block" do
        expect(column.content(template, instance)).to eq(instance)
      end
    end
  end

  context "without a block" do
    subject(:column) { Trestle::Table::Column.new(table, :my_field, options) }

    describe "#content" do
      let(:instance) { double(my_field: "Field content") }

      it "sends the field name to the instance" do
        expect(column.content(template, instance)).to eq("Field content")
      end
    end
  end

  describe "auto-formatting" do
    it "automatically formats timestamp values" do
      time = Time.now
      timestamp = double

      column = Trestle::Table::Column.new(table, :time) { |instance| instance }

      expect(template).to receive(:timestamp).with(time).and_return(timestamp)
      expect(column.content(template, time)).to eq(timestamp)
    end

    it "automatically formats date values" do
      date = Date.today
      datestamp = double

      column = Trestle::Table::Column.new(table, :date) { |instance| instance }

      expect(template).to receive(:datestamp).with(date).and_return(datestamp)
      expect(column.content(template, date)).to eq(datestamp)
    end
  end

  describe "linking" do
    def admin_double(path)
      klass = Class.new(Trestle::Admin) do
        def self.path(*)
          @path
        end
      end
      klass.instance_variable_set("@path", path)
      klass
    end

    let(:admin) { admin_double("/test/123") }
    let(:alternative_admin) { admin_double("/alternate/123") }
    let(:template) { double(admin: admin) }
    let(:instance) { double }
    let(:link) { double }

    it "links to the instance if the `link` option is true" do
      column = Trestle::Table::Column.new(table, :linked, link: true) { |instance| "Link Text" }

      expect(admin).to receive(:path).with(:show, id: instance).and_return("/test/123")
      expect(template).to receive(:link_to).with("Link Text", "/test/123").and_return(link)
      expect(column.content(template, instance)).to eq(link)
    end

    it "reformats and rewords if the column text is blank" do
      column = Trestle::Table::Column.new(table, :linked, link: true) { |instance| "" }

      expect(admin).to receive(:path).with(:show, id: instance).and_return("/test/123")
      expect(template).to receive(:link_to).with("None set", "/test/123", class: "empty").and_return(link)
      expect(column.content(template, instance)).to eq(link)
    end

    it "links to the given admin if specified in the column options" do
      column = Trestle::Table::Column.new(table, :linked, link: true, admin: alternative_admin) { |instance| "Link Text" }

      expect(template).to receive(:link_to).with("Link Text", "/alternate/123").and_return(link)
      expect(column.content(template, instance)).to eq(link)
    end

    context "within a table with an alternate admin specified" do
      let(:table) { Trestle::Table.new(admin: alternative_admin) }

      it "links to the table's admin" do
        column = Trestle::Table::Column.new(table, :linked, link: true) { |instance| "Link Text" }

        expect(template).to receive(:link_to).with("Link Text", "/alternate/123").and_return(link)
        expect(column.content(template, instance)).to eq(link)
      end
    end
  end
end
