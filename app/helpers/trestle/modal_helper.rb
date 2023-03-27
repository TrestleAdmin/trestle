module Trestle
  module ModalHelper
    def turbo_stream_modal(template: action_name)
      template = render_to_string template: action_name, prefixes: _prefixes, formats: [:html], layout: "trestle/modal"
      %(<turbo-stream action="modal"><template>#{template}</template></turbo-stream>).html_safe
    end
  end
end
