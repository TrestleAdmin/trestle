require 'spec_helper'

describe Trestle::ModelName do
  include I18nHelper

  subject(:name) { Trestle::ModelName.new(klass) }

  let(:klass) { stub_const("TestPost", Class.new(ActiveRecord::Base)) }

  it "converts to string" do
    expect(name.to_s).to eq("Test Post")
  end

  it "delegates string methods to to_s" do
    expect(name.downcase).to eq("test post")
    expect(name.upcase).to eq("TEST POST")
    expect(name.titleize).to eq("Test Post")
    expect(name.titlecase).to eq("Test Post")
  end

  it "has a singular form" do
    expect(name.singular).to eq("Test Post")
    expect(name.singularize).to eq("Test Post")
  end

  it "has a plural form" do
    expect(name.plural).to eq("Test Posts")
    expect(name.pluralize).to eq("Test Posts")
  end

  it "is equal to another ModelName with the same class" do
    expect(name).to eq(Trestle::ModelName.new(klass))
    expect(name).not_to eq(Trestle::ModelName.new(String))
  end

  context "both singular and plural i18n translations provided" do
    it "uses the translations from i18n" do
      with_translations(:en, activerecord: { models: { test_post: { one: "One Test Post", other: "Many Test Posts" } } }) do
        expect(name.singular).to eq("One Test Post")
        expect(name.plural).to eq("Many Test Posts")
      end
    end
  end

  context "model i18n translation provided" do
    it "pluralizes based on singular version and inflection rules" do
      with_translations(:en, activerecord: { models: { test_post: "One Test Post" } }) do
        expect(name.singular).to eq("One Test Post")
        expect(name.plural).to eq("One Test Posts")
      end
    end
  end

  context "plural i18n translation missing" do
    it "pluralizes based on singular version and inflection rules" do
      with_translations(:en, activerecord: { models: { test_post: { one: "One Test Post" } } }) do
        expect(name.singular).to eq("One Test Post")
        expect(name.plural).to eq("One Test Posts")
      end
    end
  end

  context "singular i18n translation missing" do
    it "falls back to non-i18n singular version" do
      with_translations(:en, activerecord: { models: { test_post: { other: "Many Test Posts" } } }) do
        expect(name.singular).to eq("Test Post")
        expect(name.plural).to eq("Many Test Posts")
      end
    end
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
