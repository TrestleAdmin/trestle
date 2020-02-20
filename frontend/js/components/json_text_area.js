
import { init } from '../core/events'
import JSONEditor from "jsoneditor";

init(function (root) {
  $(root).find('[data-enable-jsoneditor]').each(function (index, element) {
    const $field = $(element).parent().find('input.json-text-area');
    let object;
    try {
      object = JSON.parse($field.val());
    } catch {
      object = {}
    }

    const editor = new JSONEditor(element, {
      mode: 'code',
      onChangeText: function (string) {
        $field.val(string)
      }
    }, object)

    editor.aceEditor.setOptions({
      maxLines: 10000
    })
  })
})
