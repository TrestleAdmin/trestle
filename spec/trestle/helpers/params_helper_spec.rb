require 'spec_helper'

require_relative '../../../app/helpers/trestle/params_helper'

describe Trestle::ParamsHelper do
  include Trestle::ParamsHelper
  
  let(:params) { ActionController::Parameters.new(sort: :field, order: "asc", ignore: "me") }

  describe "#persistent_params" do
    it "only returns params that should be persistent" do
      expect(persistent_params).to eq(ActionController::Parameters.new(sort: :field, order: "asc").permit!)
    end
  end
end
