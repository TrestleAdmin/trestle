require 'spec_helper'

describe Trestle::Table::ActionsColumn do
  let(:table) { Trestle::Table.new(admin: admin) }
  let(:admin) { double }
  let(:instance) { double }
  let(:template) { double }

  subject(:column) do
    Trestle::Table::ActionsColumn.new(table)
  end

  describe "#renderer" do
    subject(:renderer) { column.renderer(template) }

    it "has an empty header" do
      expect(renderer.header).to be_blank
    end

    it "has a class of 'actions'" do
      expect(renderer.classes).to eq("actions")
    end

    it "has empty data" do
      expect(renderer.data).to eq({})
    end

    describe "#content" do
      let(:template) { double(admin: admin, icon: double, link_to: double, concat: nil) }

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

    describe "#button" do
      let(:button) { double }

      it "appends a button link to the template" do
        expect(template).to receive(:link_to).with("Test", "/path", class: ["btn-info", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.button("Test", "/path", class: "btn-info")
      end
    end

    describe "#delete" do
      let(:button) { double }
      let(:icon) { double }
      let(:template) { double(admin: admin) }

      it "appends a delete link to the template" do
        expect(template).to receive(:icon).with("fa fa-trash").and_return(icon)
        expect(template).to receive(:admin_url_for).with(instance, admin: admin, action: :destroy).and_return("/test/123")
        expect(template).to receive(:link_to).with(icon, "/test/123", method: :delete, data: { toggle: "confirm-delete", placement: "left" }, class: ["btn-danger", "btn"]).and_return(button)
        expect(template).to receive(:concat).with(button)

        builder.delete
      end
    end
  end
end
