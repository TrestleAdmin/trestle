Trestle.admin(:theme, scope: Components) do
  menu do
    group :components do
      item :theme, icon: "fas fa-palette", priority: 8
    end
  end

  helper do
    def alert_message(html_class)
      <<-HTML.html_safe
        This custom alert has the <code>#{html_class}</code> class. This is the <a href="#">Link style</a>.
      HTML
    end
  end
end
