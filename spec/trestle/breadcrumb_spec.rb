require 'spec_helper'

describe Trestle::Breadcrumb::Trail do
  let(:breadcrumbs) { [Trestle::Breadcrumb.new("Home", "/"), Trestle::Breadcrumb.new("Child")] }
  
  subject(:trail) { Trestle::Breadcrumb::Trail.new(breadcrumbs) }

  it "is iterable" do
    expect { |b| trail.each(&b) }.to yield_successive_args(
      Trestle::Breadcrumb.new("Home", "/"),
      Trestle::Breadcrumb.new("Child")
    )
  end

  describe "#append" do
    it "adds a breadcrumb to the end of the trail" do
      trail.append("End", "/end")
      expect(trail.last).to eq(Trestle::Breadcrumb.new("End", "/end"))
    end
  end

  describe "#prepend" do
    it "adds a breadcrumb to the beginning of the trail" do
      trail.prepend("Start", "/start")
      expect(trail.first).to eq(Trestle::Breadcrumb.new("Start", "/start"))
    end
  end
end
