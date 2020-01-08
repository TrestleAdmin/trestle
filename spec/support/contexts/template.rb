RSpec.shared_context "template" do
  let(:admin) { nil }
  let(:template) { ActionView::Base.respond_to?(:empty) ? ActionView::Base.empty : ActionView::Base.new }

  before(:each) do
    template.extend(Trestle::IconHelper)
    template.extend(Trestle::UrlHelper)

    allow(template).to receive(:admin).and_return(admin)
  end
end
