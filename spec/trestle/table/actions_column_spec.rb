require 'spec_helper'

describe Trestle::Table::ActionsColumn do
  let(:options) { {} }
  let(:table) { Trestle::Table.new(admin: admin) }
  let(:admin) { double }
  let(:instance) { double }
  let(:template) { double }

  before(:each) do
    allow(Trestle).to receive(:lookup).and_return(admin)
  end

  subject(:column) do
    Trestle::Table::ActionsColumn.new(table, options)
  end

  describe "#renderer" do
    subject(:renderer) { column.renderer(template) }

    describe "#header" do
      it "is empty by default" do
        expect(renderer.header).to be_blank
      end

      context "with options[:header]" do
        let(:options) { { header: "Custom Header" } }

        it "returns the header specified in options" do
          expect(renderer.header).to eq("Custom Header")
        end
      end
    end

    describe "#classes" do
      let(:options) { { class: "custom-class" } }

      it "includes class of 'actions'" do
        expect(renderer.classes).to include("actions")
      end

      it "includes classes specified in options" do
        expect(renderer.classes).to include("custom-class")
      end
    end

    describe "#data" do
      let(:options) { { data: { attr: "custom" } } }

      it "returns data specified in options" do
        expect(renderer.data).to eq({ attr: "custom" })
      end
    end

    describe "#content" do
      let(:template) { double(icon: double, link_to: double, concat: nil) }

      it "renders the actions block" do
        expect(template).to receive(:with_output_buffer).and_yield
        expect(template).to receive(:instance_exec).with(Trestle::Table::ActionsColumn::ActionsBuilder, &column.block)
        expect(template).to receive(:admin_url_for).with(instance, admin: admin, action: :destroy).and_return("/test/123")

        renderer.content(instance)
      end
    end
  end

  describe Trestle::Table::ActionsColumn::ActionsBuilder do
    subject(:builder) { Trestle::Table::ActionsColumn::ActionsBuilder.new(column, template, instance) }

    let(:button) { double }
    let(:icon) { double }

    describe "#button" do
      it "appends a button link to the template" do
        expect(template).to receive(:link_to).with("Test", "/path", class: ["btn-info", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.button("Test", "/path", class: "btn-info")
      end
    end

    describe "#delete" do
      it "appends a delete link to the template" do
        expect(template).to receive(:icon).with("fa fa-trash").and_return(icon)
        expect(template).to receive(:admin_url_for).with(instance, admin: admin, action: :destroy).and_return("/test/123")
        expect(template).to receive(:link_to).with(icon, "/test/123", method: :delete, data: { toggle: "confirm-delete", placement: "left" }, class: ["btn-danger", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.delete
      end
    end

    describe "#show" do
      it "appends a show link to the template" do
        expect(template).to receive(:icon).with("fa fa-info").and_return(icon)
        expect(template).to receive(:admin_url_for).with(instance, admin: admin, action: :show).and_return("/test/123")
        expect(template).to receive(:link_to).with(icon, "/test/123", class: ["btn-info", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.show
      end
    end

    describe "#edit" do
      it "appends an edit link to the template" do
        expect(template).to receive(:icon).with("fa fa-pencil").and_return(icon)
        expect(template).to receive(:admin_url_for).with(instance, admin: admin, action: :edit).and_return("/test/123")
        expect(template).to receive(:link_to).with(icon, "/test/123", class: ["btn-warning", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.edit
      end
    end
  end
end
