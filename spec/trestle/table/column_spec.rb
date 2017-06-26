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
      let(:options) { { header: "Custom Header", sort: false } }

      it "returns the header based on the internationalized field name" do
        expect(I18n).to receive(:t).with("admin.table.headers.my_field", default: "Custom Header").and_return("Custom Header")
        expect(renderer.header).to eq("Custom Header")
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
      context "with a block" do
        subject(:column) do
          Trestle::Table::Column.new(table, :my_field, options) { |instance| instance }
        end

        it "returns the result of the block" do
          expect(renderer.content(instance)).to eq(instance)
        end
      end

      context "without a block" do
        it "sends the field name to the instance" do
          expect(instance).to receive(:my_field).and_return("Field content")
          expect(renderer.content(instance)).to eq("Field content")
        end
      end

      describe "formatting" do
        it "automatically formats timestamp values" do
          time = Time.now
          timestamp = double

          expect(instance).to receive(:my_field).and_return(time)
          expect(template).to receive(:timestamp).with(time).and_return(timestamp)

          expect(renderer.content(instance)).to eq(timestamp)
        end

        it "automatically formats date values" do
          date = Date.today
          datestamp = double

          expect(instance).to receive(:my_field).and_return(date)
          expect(template).to receive(:datestamp).with(date).and_return(datestamp)

          expect(renderer.content(instance)).to eq(datestamp)
        end

        it "returns 'none' text for nil values" do
          blank = double

          expect(instance).to receive(:my_field).and_return(nil)
          expect(template).to receive(:content_tag).with(:span, "None", class: "blank").and_return(blank)

          expect(renderer.content(instance)).to eq(blank)
        end

        it "automatically formats true values" do
          status = double
          icon = double

          expect(instance).to receive(:my_field).and_return(true)
          expect(template).to receive(:icon).with("fa fa-check").and_return(icon)
          expect(template).to receive(:status_tag).with(icon, :success).and_return(status)

          expect(renderer.content(instance)).to eq(status)
        end

        it "leaves false values empty" do
          expect(instance).to receive(:my_field).and_return(false)
          expect(renderer.content(instance)).to be_nil
        end

        it "calls display for model-like values" do
          representation = double
          model = double(id: "123")

          expect(instance).to receive(:my_field).and_return(model)
          allow(template).to receive(:admin_link_to).and_return(representation)
          expect(template).to receive(:display).with(model).and_return(representation)
          expect(renderer.content(instance)).to eq(representation)
        end

        context "options[:format] = :currency" do
          let(:options) { { format: :currency } }

          it "formats value as currency" do
            currency = double

            expect(instance).to receive(:my_field).and_return(123.45)
            expect(template).to receive(:number_to_currency).with(123.45).and_return(currency)
            expect(renderer.content(instance)).to eq(currency)
          end
        end
      end

      describe "linking" do
        it "automatically links model-like values to their admin if available" do
          link = double
          representation = double
          model = double(id: "123")

          expect(instance).to receive(:my_field).and_return(model)
          allow(template).to receive(:display).with(model).and_return(representation)
          expect(template).to receive(:admin_link_to).with(representation, model).and_return(link)
          expect(renderer.content(instance)).to eq(link)
        end

        context "options[:link] is false" do
          let(:options) { { link: false } }

          it "does not link model-like values" do
            representation = double
            model = double(id: "123")

            expect(instance).to receive(:my_field).and_return(model)
            allow(template).to receive(:display).with(model).and_return(representation)
            expect(template).not_to receive(:admin_link_to)
            expect(renderer.content(instance)).to eq(representation)
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
