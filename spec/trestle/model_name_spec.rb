require 'spec_helper'

describe Trestle::ModelName do
  let(:klass) { stub_const("TestPost", Class.new(ActiveRecord::Base)) }
  subject(:name) { Trestle::ModelName.new(klass) }

  it "converts to string" do
    expect(name.to_s).to eq("Test post")
  end

  it "delegates string methods to to_s" do
    expect(name.downcase).to eq("test post")
    expect(name.upcase).to eq("TEST POST")
    expect(name.titleize).to eq("Test Post")
    expect(name.titlecase).to eq("Test Post")
  end

  it "has a singular form" do
    expect(name.singular).to eq("Test post")
    expect(name.singularize).to eq("Test post")
    expect(name.human).to eq("Test post")
  end

  it "has a plural form" do
    expect(name.plural).to eq("Test posts")
    expect(name.pluralize).to eq("Test posts")
  end

  it "is equal to another ModelName with the same class" do
    expect(name).to eq(Trestle::ModelName.new(klass))
    expect(name).not_to eq(Trestle::ModelName.new(String))
  end

  context "plain ruby class" do
    let(:klass) { stub_const("Article", Class.new) }

    it "has a singular form" do
      expect(name.singular).to eq("Article")
    end

    it "has a plural form" do
      expect(name.plural).to eq("Articles")
    end
  end
end
