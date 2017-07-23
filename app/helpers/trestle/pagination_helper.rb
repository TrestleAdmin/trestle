module Trestle
  module PaginationHelper
    # Custom version of Kaminari's page_entries_info helper to use a
    # Trestle-scoped I18n key and add a delimiter to the total count.
    def page_entries_info(collection, options = {})
      entry_name = options[:entry_name] || "entry"
      entry_name = entry_name.pluralize unless collection.total_count == 1

      if collection.total_pages < 2
        t('trestle.helpers.page_entries_info.one_page.display_entries', entry_name: entry_name, count: collection.total_count, default: "Displaying <strong>all %{count}</strong> %{entry_name}")
      else
        first = number_with_delimiter(collection.offset_value + 1)
        last  = number_with_delimiter((sum = collection.offset_value + collection.limit_value) > collection.total_count ? collection.total_count : sum)
        total = number_with_delimiter(collection.total_count)

        t('trestle.helpers.page_entries_info.more_pages.display_entries', entry_name: entry_name, first: first, last: last, total: total, default: "Displaying %{entry_name} <strong>%{first}&nbsp;-&nbsp;%{last}</strong> of <b>%{total}</b>")
      end.html_safe
    end
  end
end
