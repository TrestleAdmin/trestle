module Trestle
  module ModalHelper
    def turbo_stream_modal(template: action_name, action: "append")
      template = turbo_stream_modal_template do
        render_to_string template: action_name, prefixes: _prefixes, formats: [:html], layout: false
      end

      %(<turbo-stream action="#{action}" target="modal">#{template}</turbo-stream>).html_safe
    end

    def turbo_stream_modal_template
      <<-EOF
      <template>
        <div class="modal fade" tabindex="-1" role="dialog" data-controller="modal">
          <div class="modal-dialog" role="document">
            #{yield}
          </div>
        </div>
      </template>
      EOF
    end
  end
end
