require 'spec_helper'

describe Trestle::Display do
  class MyClass
    def id
      123
    end
  end

  let(:instance) { MyClass.new }
  let(:display_methods) { [:name, :email, :to_s] }

  subject { Trestle::Display.new(instance) }

  before(:each) do
    allow(Trestle.config).to receive(:display_methods).and_return(display_methods)
  end

  it "calls a display method if defined" do
    allow(instance).to receive(:email).and_return("EMAIL")
    expect(subject.to_s).to eq("EMAIL")
  end

  it "tries display methods in order" do
    allow(instance).to receive(:name).and_return("NAME")
    allow(instance).to receive(:email).and_return("EMAIL")
    expect(subject.to_s).to eq("NAME")
  end

  it "falls back to a default representation if the object does not respond to any of the display methods" do
    expect(subject.to_s).to eq("MyClass (#123)")
  end

  it "does not use the fallback if the object explicitly defines #to_s" do
    allow(instance).to receive(:to_s).and_return("Custom #to_s")
    expect(subject.to_s).to eq("Custom #to_s")
  end
end
