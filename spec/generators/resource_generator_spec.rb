require 'spec_helper'

require 'generators/trestle/resource/resource_generator'

describe Trestle::Generators::ResourceGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  before do
    prepare_destination
  end

  describe "the generated files" do
    before do
      run_generator %w(posts)
    end

    describe "the admin resource" do
      subject { file("app/admin/posts_admin.rb") }

      it { is_expected.to exist }
      it { is_expected.to contain "Trestle.resource(:posts) do" }
    end
  end

  context "with a scoped resource" do
    describe "the generated files" do
      before do
        run_generator %w(Namespace::Post)
      end

      describe "the admin resource" do
        subject { file("app/admin/namespace/posts_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to contain "Trestle.resource(:posts, scope: Namespace) do" }
      end
    end
  end
end
