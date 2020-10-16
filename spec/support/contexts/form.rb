RSpec.shared_context "form" do |field, value|
  include_context "template" do
    let(:admin) { double(readonly?: false) }
  end

  let(:builder) { Trestle::Form::Builder.new(object_name, object, template, options) }

  let(:object_name) { :article }
  let(:object) { double(errors: ActiveModel::Errors.new([])) }

  let(:options) { {} }

  before(:each) do
    allow(object).to receive_messages(field => value)
  end if field
end
