module Trestle
  module ContentSecurityPolicyHelper
    def javascript_include_tag(*sources)
      options = sources.extract_options!.stringify_keys

      if !options.key?("nonce") && content_security_policy_nonce
        if Rails.gem_version >= Gem::Version.new("6.0.0")
          options["nonce"] = true
        else
          options["nonce"] = content_security_policy_nonce
        end
      end

      sources << options

      super(*sources)
    end

    def stylesheet_link_tag(*sources)
      options = sources.extract_options!.stringify_keys

      if !options.key?("nonce") && content_security_policy_nonce
        if Rails.gem_version >= Gem::Version.new("8.0.0")
          options["nonce"] = true
        else
          options["nonce"] = content_security_policy_nonce
        end
      end

      sources << options

      super(*sources)
    end
  end
end