module Trestle
  module FlashHelper
    def normalize_flash_alert(flash)
      flash.is_a?(Hash) ? flash.with_indifferent_access : { message: flash }
    end

    def debug_form_errors?
      Trestle.config.debug_form_errors && instance_has_errors?
    end

    def instance_has_errors?
      instance.errors.any? rescue false
    end

    def turbo_stream_update_flash
      <<-EOF
      <turbo-stream action="update" target="flash">
        <template>
          #{render_to_string(partial: "trestle/flash/flash", formats: [:html])}
        </template>
      </turbo-stream>
      EOF
    end
  end
end
