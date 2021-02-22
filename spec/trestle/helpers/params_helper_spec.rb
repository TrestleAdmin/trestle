require 'spec_helper'

require_relative '../../../app/helpers/trestle/params_helper'

describe Trestle::ParamsHelper do
  include Trestle::ParamsHelper

  let(:params) { ActionController::Parameters.new(sort: :field, order: "asc", ignore: "me") }

  describe "#persistent_params" do
    it "only returns params that should be persistent" do
      expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc").permit!)
    end

    context "when Trestle.config.persistent_params contains hashes and arrays" do
      before(:each) do
        expect(Trestle.config).to receive(:persistent_params).and_return([:sort, { hash: {} }, :order, { array: [] }])
      end

      let(:params) do
        ActionController::Parameters.new({
          sort: :field,
          order: "asc",
          ignore: "me",
          hash: { key: "value" },
          ignore_hash: { abc: "123" },
          array: ["foo", "bar", "baz"],
          ignore_array: ["one", "two"]
        })
      end

      it "includes persistent hash and array params" do
        expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc", hash: { key: "value" }, array: ["foo", "bar", "baz"]).permit!)
      end
    end
  end
end
