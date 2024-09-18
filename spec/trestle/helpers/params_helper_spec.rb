require 'spec_helper'

describe Trestle::ParamsHelper, type: :helper do
  describe "#persistent_params" do
    let(:params) { ActionController::Parameters.new(sort: :field, order: "asc", ignore: "me") }

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

  describe "#serialize_persistent_params" do
    before(:each) do
      allow(Trestle.config).to receive(:persistent_params).and_return([:sort, { array: [] }, :order, { hash: {} }])
    end

    let(:params) { ActionController::Parameters.new(sort: :field, order: "asc", ignore: "me", array: ["foo", "bar", "baz"], hash: { key1: "value1", key2: "value2" },) }

    it "returns hidden input tags for each parameter" do
      result = serialize_persistent_params

      expect(result).to have_tag("input", with: { type: "hidden", name: "sort", value: "field" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "order", value: "asc" })
      expect(result).not_to have_tag("input", with: { type: "hidden", name: "ignore", value: "me" })
    end

    it "returns a hidden input tag for each individual array parameter" do
      result = serialize_persistent_params

      expect(result).to have_tag("input", with: { type: "hidden", name: "array[]", value: "foo" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "array[]", value: "bar" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "array[]", value: "baz" })
    end

    it "returns a hidden input tag for each individual hash parameter" do
      result = serialize_persistent_params

      expect(result).to have_tag("input", with: { type: "hidden", name: "hash[key1]", value: "value1" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "hash[key2]", value: "value2" })
    end

    it "does not include specific params matching the :except option (singular)" do
      result = serialize_persistent_params(except: :order)

      expect(result).not_to have_tag("input", with: { type: "hidden", name: "order", value: "asc" })
    end

    it "does not include specific params matching the :except option (array)" do
      result = serialize_persistent_params(except: [:order, :array])

      expect(result).not_to have_tag("input", with: { type: "hidden", name: "order", value: "asc" })
      expect(result).not_to have_tag("input", with: { type: "hidden", name: "array[]", value: "foo" })
      expect(result).not_to have_tag("input", with: { type: "hidden", name: "array[]", value: "bar" })
      expect(result).not_to have_tag("input", with: { type: "hidden", name: "array[]", value: "baz" })
    end

    it "only includes params matching the :only option (singular)" do
      result = serialize_persistent_params(only: :sort)

      expect(result).to have_tag("input", count: 1)
      expect(result).to have_tag("input", with: { type: "hidden", name: "sort", value: "field" })
    end

    it "only includes params matching the :only option (array)" do
      result = serialize_persistent_params(only: [:sort, :hash])

      expect(result).to have_tag("input", count: 3)
      expect(result).to have_tag("input", with: { type: "hidden", name: "sort", value: "field" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "hash[key1]", value: "value1" })
      expect(result).to have_tag("input", with: { type: "hidden", name: "hash[key2]", value: "value2" })
    end
  end
end
