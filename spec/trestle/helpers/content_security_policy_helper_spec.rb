require 'spec_helper'

describe Trestle::ContentSecurityPolicyHelper, type: :helper do
  shared_context "rails_version" do |version_string|
    before do
      allow(Rails).to receive(:gem_version).and_return(Gem::Version.new(version_string))
    end
  end

  describe "#javascript_include_tag" do
    let(:script_name) { "application" }

    context "when content_security_policy is enabled" do
      context "when content_security_policy_nonce is 'testnonce'" do
        before { allow(helper).to receive(:content_security_policy_nonce).and_return("testnonce") }

        it "adds the nonce attribute" do
          expect(helper.javascript_include_tag(script_name)).to have_tag("script[src*='#{script_name}'][nonce='testnonce']")
        end

        it "does not override an existing nonce option" do
          expect(helper.javascript_include_tag(script_name, nonce: "custom")).to have_tag("script[src*='#{script_name}'][nonce='custom']")
        end

        it "preserves other options" do
          expect(helper.javascript_include_tag(script_name, defer: true)).to have_tag("script[src*='#{script_name}'][nonce='testnonce'][defer='defer']")
        end
      end
    end

    context "when content_security_policy is enabled on rails versions before nonce: true" do
      context "when content_security_policy_nonce is 'testnonce'" do
        before { allow(helper).to receive(:content_security_policy_nonce).and_return("testnonce") }

        context "with Rails < 6.0.0" do
          include_context "rails_version", "5.2.0"
          it "adds nonce attribute with the direct nonce value" do
            expect(helper.javascript_include_tag(script_name)).to have_tag("script[src*='#{script_name}'][nonce='testnonce']")
          end
        end
      end
    end

    context "when content_security_policy_nonce is nil (CSP disabled)" do
      before { allow(helper).to receive(:content_security_policy_nonce).and_return(nil) }

      it "does not add a nonce attribute" do
        expect(helper.javascript_include_tag(script_name)).to have_tag("script[src*='#{script_name}']")
        expect(helper.javascript_include_tag(script_name)).not_to include("nonce=")
      end
    end
  end

  describe "#stylesheet_link_tag" do
    let(:style_name) { "application" }

    context "when content_security_policy is enabled" do
      context "when content_security_policy_nonce is 'testnonce'" do
        before { allow(helper).to receive(:content_security_policy_nonce).and_return("testnonce") }

        it "adds the nonce attribute" do
          expect(helper.stylesheet_link_tag(style_name)).to have_tag("link[href*='#{style_name}'][rel='stylesheet'][nonce='testnonce']")
        end

        it "does not override an existing nonce option" do
          expect(helper.stylesheet_link_tag(style_name, nonce: "custom")).to have_tag("link[href*='#{style_name}'][rel='stylesheet'][nonce='custom']")
        end

        it "preserves other options like media" do
          expect(helper.stylesheet_link_tag(style_name, media: "print")).to have_tag("link[href*='#{style_name}'][rel='stylesheet'][media='print'][nonce='testnonce']")
        end
      end
    end

    context "when content_security_policy is enabled on Rails versions before nonce: true" do
      context "when content_security_policy_nonce is 'testnonce'" do
        before { allow(helper).to receive(:content_security_policy_nonce).and_return("testnonce") }

        context "with Rails < 8.0.0" do
          it "adds nonce attribute with the direct nonce value" do
            expect(helper.stylesheet_link_tag(style_name)).to have_tag("link[href*='#{style_name}'][rel='stylesheet'][nonce='testnonce']")
          end
        end
      end
    end

    context "when content_security_policy_nonce is nil (CSP disabled)" do
      before { allow(helper).to receive(:content_security_policy_nonce).and_return(nil) }

      it "does not add a nonce attribute" do
        expect(helper.stylesheet_link_tag(style_name)).to have_tag("link[href*='#{style_name}'][rel='stylesheet']")
        expect(helper.stylesheet_link_tag(style_name)).not_to include("nonce=")
      end
    end
  end
end
