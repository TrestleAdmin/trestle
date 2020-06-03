require 'spec_helper'

describe Trestle::Form::Renderer, type: :helper do
  include_context "template" do
    before(:each) do
      template.extend(Trestle::GridHelper)

      allow(template).to receive(:form) { form }
    end
  end

  let(:instance) { double }
  let(:form) { double }

  subject(:renderer) { Trestle::Form::Renderer.new(template) }

  def render_form(&block)
    renderer.render_form(instance, &block)
  end

  it "appends form builder methods to the result" do
    expect(form).to receive(:text_field).with(:name).and_return('TEXT FIELD')
    result = render_form { text_field :name }
    expect(result).to eq("TEXT FIELD")
  end

  it "append whitelisted helpers to the result" do
    result = render_form do
      row do
        col(3) {}
        col(9) {}
      end
    end

    expect(result).to eq('<div class="row"><div class="col-3"></div><div class="col-9"></div></div>')
  end

  it "does not append non-whitelisted helpers to the result" do
    result = render_form { icon("fa fa-warning"); nil }
    expect(result).to be_blank
  end

  it "renders hooks within the context of the renderer" do
    Trestle.config.hook("myhook") do
      row do
        col(3) {}
        col(9) {}
      end
    end

    result = render_form do
      hook("myhook")
    end

    expect(result).to eq('<div class="row"><div class="col-3"></div><div class="col-9"></div></div>')
  end

  it "correctly concats additional content" do
    result = render_form do
      row {}
      concat "FROM CONCAT"
    end

    expect(result).to eq('<div class="row"></div>FROM CONCAT')
  end

  describe "#fields_for" do
    let(:subform) { double }

    it "sends form builder methods to the subform" do
      expect(form).to receive(:fields_for).with(:subobject).and_yield(subform)
      expect(subform).to receive(:text_field).with(:name).and_return('SUB:TEXT FIELD')

      result = render_form do
        fields_for :subobject do
          text_field :name
        end
      end

      expect(result).to eq("SUB:TEXT FIELD")
    end
  end
end
