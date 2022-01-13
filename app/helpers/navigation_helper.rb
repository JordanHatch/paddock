module NavigationHelper
  def section_nav_link(label, path, section_name)
    nav_link(label,
             path,
             list_item_class: "section-#{section_name}",
             match_prefix: true)
  end

  def nav_link(label, path, list_item_class: nil, link_class: nil, match_prefix: false)
    if match_prefix
      prefix_matches = request.fullpath =~ /^#{Regexp.escape(path)}/
      selected = current_page?(path) || prefix_matches
    else
      selected = current_page?(path)
    end

    styles = [list_item_class]
    styles << 'selected' if selected

    content_tag(:li, class: styles.compact.join(' ')) do
      link_to label, path, class: link_class
    end
  end
end
