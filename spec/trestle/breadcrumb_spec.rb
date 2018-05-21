require 'spec_helper'

describe Trestle::Breadcrumb do
  describe ".cast" do
    context "when passed a Breadcrumb object" do
      it "returns the breadcrumb" do
        breadcrumb = Trestle::Breadcrumb.new("Home", "/")
        expect(Trestle::Breadcrumb.cast(breadcrumb)).to eq(breadcrumb)
      end
    end

    context "when passed a string" do
      it "returns a breadcrumb created with the given label" do
        breadcrumb = Trestle::Breadcrumb.new("Home")
        expect(Trestle::Breadcrumb.cast("Home")).to eq(breadcrumb)
      end
    end

    context "when passed an array" do
      it "returns a breadcrumb created with the array elements" do
        breadcrumb = Trestle::Breadcrumb.new("Home", "/")
        expect(Trestle::Breadcrumb.cast(["Home", "/"])).to eq(breadcrumb)
      end
    end

    context "when passed nil" do
      it "returns nil" do
        expect(Trestle::Breadcrumb.cast(nil)).to be_nil
      end
    end

    context "when passed false" do
      it "returns nil" do
        expect(Trestle::Breadcrumb.cast(false)).to be_nil
      end
    end

    context "when passed anything else" do
      it "raises an ArgumentError" do
        expect {
          Trestle::Breadcrumb.cast(123)
        }.to raise_error(ArgumentError, "Unable to cast 123 to Breadcrumb")
      end
    end
  end
end

describe Trestle::Breadcrumb::Trail do
  let(:breadcrumbs) { [Trestle::Breadcrumb.new("Home", "/"), Trestle::Breadcrumb.new("Child")] }

  subject(:trail) { Trestle::Breadcrumb::Trail.new(breadcrumbs) }

  it "is iterable" do
    expect { |b| trail.each(&b) }.to yield_successive_args(
      Trestle::Breadcrumb.new("Home", "/"),
      Trestle::Breadcrumb.new("Child")
    )
  end

  it "is equal to a trail with identical breadcrumbs" do
    other = Trestle::Breadcrumb::Trail.new(breadcrumbs)
    expect(other).to eq(trail)
  end

  it "removes nils from the breadcrumbs array" do
    trail_with_nil = Trestle::Breadcrumb::Trail.new(breadcrumbs + [nil])
    expect(trail_with_nil).to eq(trail)
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
