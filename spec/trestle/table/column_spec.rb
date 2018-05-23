require 'spec_helper'

describe Trestle::Table::Column do
  let(:options) { {} }
  let(:template) { double }
  let(:table) { Trestle::Table.new(sortable: true) }

  let(:instance) { double }

  subject(:column) do
    Trestle::Table::Column.new(table, :my_field, options)
  end

  describe "#sortable?" do
    context "with a block" do
      subject(:column) do
        Trestle::Table::Column.new(table, :my_field, options) { |instance| instance }
      end

      it { is_expected.to_not be_sortable }

      context "with options[:sort] = :field" do
        let(:options) { { sort: :field } }
        it { is_expected.to be_sortable }
      end
    end

    context "without a block" do
      it { is_expected.to be_sortable }

      context "with options[:sort] = false" do
        let(:options) { { sort: false } }
        it { is_expected.to_not be_sortable }
      end

      context "with a non-sortable table" do
        let(:table) { Trestle::Table.new(sortable: false) }
        it { is_expected.to_not be_sortable }
      end
    end
  end

  describe "#renderer" do
    subject(:renderer) { column.renderer(template) }

    describe "#header" do
      context "with options[:header] set" do
        let(:options) { { header: "Custom Header", sort: false } }

        it "uses options[:header] as the field name" do
          expect(renderer.header).to eq("Custom Header")
        end
      end

      context "with options[:header] unset" do
        let(:options) { { sort: false } }

        it "returns the header based on the internationalized field name" do
          expect(I18n).to receive(:t).with("admin.table.headers.my_field", default: "My Field").and_return("My Field")
          expect(renderer.header).to eq("My Field")
        end
      end
    end

    describe "#classes" do
      let(:options) { { class: "custom-class", align: :center } }

      it "returns classes specified in options" do
        expect(renderer.classes).to include("custom-class")
      end

      it "returns an alignment class" do
        expect(renderer.classes).to include("text-center")
      end
    end

    describe "#data" do
      let(:options) { { data: { attr: "custom" } } }

      it "returns data specified in options" do
        expect(renderer.data).to eq({ attr: "custom" })
      end
    end

    describe "#content" do
      before(:each) do
        allow(template).to receive(:format_value) { |v| v }
      end

      context "with a block" do
        subject(:column) do
          Trestle::Table::Column.new(table, :my_field, options) { |instance| instance }
        end

        it "returns the result of the block" do
          allow(template).to receive(:capture).and_yield
          allow(template).to receive(:instance_exec).and_return(instance)
          expect(renderer.content(instance)).to eq(instance)
        end
      end

      context "without a block" do
        it "sends the field name to the instance" do
          expect(instance).to receive(:my_field).and_return("Field content")
          expect(renderer.content(instance)).to eq("Field content")
        end
      end

      describe "linking" do
        it "automatically links model-like values to their admin if available" do
          link = double
          model = double(id: "123")

          expect(instance).to receive(:my_field).and_return(model)
          expect(template).to receive(:admin_link_to).with(model, model).and_return(link)
          expect(renderer.content(instance)).to eq(link)
        end

        context "options[:link] is false" do
          let(:options) { { link: false } }

          it "does not link model-like values" do
            model = double(id: "123")

            expect(instance).to receive(:my_field).and_return(model)
            expect(template).not_to receive(:admin_link_to)
            expect(renderer.content(instance)).to eq(model)
          end
        end

        context "options[:link] is true" do
          let(:options) { { link: true } }

          it "links to the current admin" do
            link = double

            expect(instance).to receive(:my_field).and_return("abc")
            expect(template).to receive(:admin_link_to).with("abc", instance, admin: nil).and_return(link)
            expect(renderer.content(instance)).to eq(link)
          end
        end

        context "options[:admin] is set" do
          let(:options) { { link: true, admin: alternative_admin } }
          let(:alternative_admin) { double }

          it "links to the specified admin" do
            link = double

            expect(instance).to receive(:my_field).and_return("abc")
            expect(template).to receive(:admin_link_to).with("abc", instance, admin: alternative_admin).and_return(link)
            expect(renderer.content(instance)).to eq(link)
          end
        end
      end
    end
  end
end
