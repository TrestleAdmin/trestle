require 'spec_helper'

describe Trestle::ResourceController, type: :request do
  include FeatureHelper

  let(:resource) { PostsAdmin }

  describe "delete record without referer" do
    let(:post) { create_test_post }

    it "does not raise an exception" do
      delete resource.instance_path(post)
    end
  end
end
