require 'spec_helper'

require_relative '../../../app/helpers/trestle/title_helper'

describe Trestle::TitleHelper do
  include Trestle::TitleHelper

  include ActionView::Helpers::CaptureHelper
  include ActionView::Context

  before(:each) { _prepare_context }

  let(:action_name) { "default" }

  describe "#title" do
    it "returns the title set by content_for" do
      content_for(:title, "Custom Title")
      expect(title).to eq("Custom Title")
    end

    it "returns a default title if not explicitly defined" do
      expect(title).to eq("Default")
    end
  end
end
