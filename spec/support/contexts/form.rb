RSpec.shared_context "form" do
  include_context "template" do
    let(:admin) { double(readonly?: false) }
  end

  subject(:builder) { Trestle::Form::Builder.new(object_name, object, template, options) }

  let(:object_name) { :article }
  let(:object) { instance_double("Article", title: "Title", errors: ActiveModel::Errors.new([])) }
  let(:options) { {} }
end
