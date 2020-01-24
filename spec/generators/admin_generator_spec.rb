require 'spec_helper'

require 'generators/trestle/admin/admin_generator'

describe Trestle::Generators::AdminGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe "the generated files" do
    before do
      run_generator %w(foobar)
    end

    describe "the admin resource" do
      subject { file("app/admin/foobar_admin.rb") }

      it { is_expected.to exist }
      it { is_expected.to contain "Trestle.admin(:foobar) do" }
    end
  end
end
