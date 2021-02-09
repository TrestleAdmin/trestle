require 'spec_helper'

describe Trestle::EvaluationContext do
  class Evaluator
    include Trestle::EvaluationContext

    def initialize(context)
      @context = context
    end
  end

  class Context
    def no_args
      "no_args called"
    end

    def single_arg(arg)
      "single_arg called with: #{arg}"
    end

    def splat_args(*args)
      "splat_args called with: #{args.join(", ")}"
    end

    def block_arg(&block)
      "block_arg called with: #{block.call}"
    end

    def kw_args(**kwargs)
      "kw_args called with: #{kwargs.map { |k, v| "#{k} => #{v}" }.join(", ")}"
    end
  end

  let(:context) { Context.new }

  subject(:evaluator) { Evaluator.new(context) }

  it "forwards methods with no args to the context" do
    expect(evaluator.no_args).to eq("no_args called")
  end

  it "forwards methods with single arg to the context" do
    expect(evaluator.single_arg("param")).to eq("single_arg called with: param")
  end

  it "forwards methods with splatted arg to the context" do
    expect(evaluator.splat_args("first", "second")).to eq("splat_args called with: first, second")
  end

  it "forwards methods with block arg to the context" do
    expect(evaluator.block_arg { "myblock" }).to eq("block_arg called with: myblock")
  end

  it "forwards methods with kwargs to the context" do
    expect(evaluator.kw_args(foo: "bar", baz: 123)).to eq("kw_args called with: foo => bar, baz => 123")
  end

  it "raises NameError if the method is not defined on the context" do
    expect { evaluator.missing_method }.to raise_error(NameError)
  end
end
