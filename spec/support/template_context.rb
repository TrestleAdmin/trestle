RSpec.shared_context "template" do
  let(:admin) { nil }
  let(:controller) { ActionView::TestCase::TestController.new }
  let(:template) { ActionView::Base.new(self, {}, controller) }

  before(:each) do
    template.extend(Trestle::IconHelper)
    template.extend(Trestle::UrlHelper)

    allow(template).to receive(:admin).and_return(admin)
  end
end
