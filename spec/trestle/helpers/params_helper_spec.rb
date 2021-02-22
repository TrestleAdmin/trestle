require 'spec_helper'

require_relative '../../../app/helpers/trestle/params_helper'

describe Trestle::ParamsHelper do
  include Trestle::ParamsHelper

  let(:params) { ActionController::Parameters.new(sort: :field, order: "asc", ignore: "me") }

  describe "#persistent_params" do
    it "only returns params that should be persistent" do
      expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc").permit!)
    end

    context "when Trestle.config.persistent_params contains an array declaration" do
      before(:each) do
        expect(Trestle.config).to receive(:persistent_params).and_return([:sort, { array: [] }, :order])
      end

      let(:params) do
        ActionController::Parameters.new({
          sort: :field,
          order: "asc",
          ignore: "me",
          array: ["foo", "bar", "baz"],
          ignore_array: ["one", "two"]
        })
      end

      it "includes the persistent array params" do
        expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc", array: ["foo", "bar", "baz"]).permit!)
      end
    end

    if Rails.gem_version > Gem::Version.new("5.1")
      context "when Trestle.config.persistent_params contains a hash declaration" do
        before(:each) do
          expect(Trestle.config).to receive(:persistent_params).and_return([:sort, { hash: {} }, :order])
        end

        let(:params) do
          ActionController::Parameters.new({
            sort: :field,
            order: "asc",
            ignore: "me",
            hash: { key: "value" },
            ignore_hash: { abc: "123" }
          })
        end

        it "includes persistent hash param" do
          expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc", hash: { key: "value" }).permit!)
        end
      end
    end
  end
end
