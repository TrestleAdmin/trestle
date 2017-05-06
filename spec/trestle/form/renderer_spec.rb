require 'spec_helper'

describe Trestle::Form::Renderer, type: :helper do
  include Trestle::GridHelper
  include Trestle::IconHelper

  let(:instance) { double }
  let(:form) { double }
  let(:template) { self }

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
        col(xs: 12) {}
      end
    end

    expect(result).to eq('<div class="row"><div class="col-xs-12"></div></div>')
  end

  it "does not append non-whitelisted helpers to the result" do
    result = render_form { icon("fa fa-warning"); nil }
    expect(result).to be_nil
  end

  it "correctly concats addition content" do
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
