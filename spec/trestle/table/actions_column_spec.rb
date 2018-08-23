require 'spec_helper'

describe Trestle::Table::ActionsColumn do
  let(:options) { {} }
  let(:table) { Trestle::Table.new(admin: admin) }
  let(:admin) { double }
  let(:instance) { double }
  let(:template) { ActionView::Base.new }

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
      let(:admin) { double(actions: [:destroy]) }

      let(:button) { double }
      let(:icon) { double }

      it "renders the actions block" do
        expect(template).to receive(:render_toolbar).with(column.toolbar, instance, admin)

        renderer.content(instance)
      end
    end
  end

  describe Trestle::Table::ActionsColumn::ActionsBuilder do
    subject(:builder) { Trestle::Table::ActionsColumn::ActionsBuilder.new(template, instance, admin) }

    let(:button) { double }

    before(:each) do
      allow(template).to receive(:icon) { |klass| template.content_tag(:i, "", class: klass) }
    end

    it "has a list of registered builder methods" do
      expect(builder.builder_methods).to eq([:button, :link, :show, :edit, :delete])
    end

    describe "#link" do
      it "appends a button link to the template" do
        expect(template).to receive(:admin_link_to)
          .with('<span class="btn-label">Test</span>', "/path", class: %w(btn btn-info))
          .and_return(button)

        expect(builder.link("Test", "/path", style: :info)).to eq(button)
      end
    end

    describe "#delete" do
      it "appends a delete link to the template" do
        expect(admin).to receive(:translate).with("buttons.delete", default: "Delete").and_return("Delete")
        expect(template).to receive(:admin_link_to)
          .with('<i class="fa fa-trash"></i> <span class="btn-label">Delete</span>', instance, admin: admin, action: :destroy, method: :delete, data: { toggle: "confirm-delete", placement: "left" }, class: %w(btn btn-danger has-icon))
          .and_return(button)

        expect(builder.delete).to eq(button)
      end
    end

    describe "#show" do
      it "appends a show link to the template" do
        expect(admin).to receive(:translate).with("buttons.show", default: "Show").and_return("Show")
        expect(template).to receive(:admin_link_to)
          .with('<i class="fa fa-info"></i> <span class="btn-label">Show</span>', instance, admin: admin, action: :show, class: %w(btn btn-info has-icon))
          .and_return(button)

        expect(builder.show).to eq(button)
      end
    end

    describe "#edit" do
      it "appends an edit link to the template" do
        expect(admin).to receive(:translate).with("buttons.edit", default: "Edit").and_return("Edit")
        expect(template).to receive(:admin_link_to)
          .with('<i class="fa fa-pencil"></i> <span class="btn-label">Edit</span>', instance, admin: admin, action: :edit, class: %w(btn btn-warning has-icon))
          .and_return(button)

        expect(builder.edit).to eq(button)
      end
    end
  end
end
