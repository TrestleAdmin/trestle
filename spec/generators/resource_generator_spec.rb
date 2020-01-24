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
      it { is_expected.to contain "table do" }
      it { is_expected.to contain "form do |post|"}
    end
  end

  context "with a singular resource" do
    describe "the generated files" do
      before do
        run_generator %w(account --singular)
      end

      describe "the admin resource" do
        subject { file("app/admin/account_admin.rb") }

        it { is_expected.to exist }
        it { is_expected.to contain "Trestle.resource(:account, singular: true) do" }
        it { is_expected.to contain "instance do" }
        it { is_expected.not_to contain "table do" }
        it { is_expected.to contain "form do |account|"}
      end
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
        it { is_expected.to contain "table do" }
        it { is_expected.to contain "form do |post|"}
      end
    end

    context "with a singular resource" do
      describe "the generated files" do
        before do
          run_generator %w(Namespace::Account --singular)
        end

        describe "the admin resource" do
          subject { file("app/admin/namespace/account_admin.rb") }

          it { is_expected.to exist }
          it { is_expected.to contain "Trestle.resource(:account, scope: Namespace, singular: true) do" }
          it { is_expected.to contain "instance do" }
          it { is_expected.not_to contain "table do" }
          it { is_expected.to contain "form do |account|"}
        end
      end
    end
  end
end
