require 'spec_helper'

describe Trestle::Table::ActionsColumn do
  include_context "template"

  let(:options) { {} }
  let(:admin) { double(path: "/admin", to_param: double, form: double(dialog?: false)) }
  let(:instance) { double }

  before(:each) do
    allow(Trestle).to receive(:lookup).and_return(admin)
  end

  subject(:column) do
    Trestle::Table::ActionsColumn.new(options)
  end

  describe "#renderer" do
    let(:table) { Trestle::Table.new(admin: admin) }

    subject(:renderer) { column.renderer(table: table, template: template) }

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
      let(:admin) { double(actions: [:destroy]) }

      it "renders the actions block" do
        expect(template).to receive(:render_toolbar).with(column.toolbar, instance, admin)

        renderer.content(instance)
      end
    end
  end

  describe Trestle::Table::ActionsColumn::ActionsBuilder do
    subject(:builder) { Trestle::Table::ActionsColumn::ActionsBuilder.new(template, instance, admin) }

    it "has a list of registered builder methods" do
      expect(builder.builder_methods).to include(:button, :link, :show, :edit, :delete)
    end

    describe "#delete" do
      it "returns a delete link" do
        expect(admin).to receive(:translate).with("buttons.delete", default: "Delete").and_return("Delete")
        expect(builder.delete).to eq(Trestle::Toolbar::Link.new(template, "Delete", instance, style: :danger, icon: "fa fa-trash", action: :destroy, method: :delete, data: { toggle: "confirm-delete", placement: "left" }))
      end
    end

    describe "#show" do
      it "returns a show link" do
        expect(admin).to receive(:translate).with("buttons.show", default: "Show").and_return("Show")
        expect(builder.show).to eq(Trestle::Toolbar::Link.new(template, "Show", instance, style: :info, icon: "fa fa-info"))
      end
    end

    describe "#edit" do
      it "returns an edit link" do
        expect(admin).to receive(:translate).with("buttons.edit", default: "Edit").and_return("Edit")
        expect(builder.edit).to eq(Trestle::Toolbar::Link.new(template, "Edit", instance, style: :warning, icon: "fa fa-pencil"))
      end
    end

    describe "#button" do
      it "returns a toolbar link instead of a button" do
        expect(builder.button("Test", "/path", style: :info)).to eq(
          Trestle::Toolbar::Link.new(template, "Test", "/path", style: :info)
        )
      end
    end
  end
end
