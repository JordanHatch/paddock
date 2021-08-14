module NavigationHelper
  def sprint_navigation_link(target_sprint)
    if controller_name == 'updates'
      update_path(target_sprint, params[:team_id])
    else
      sprint_path(target_sprint)
    end
  end

  def section_nav_link(label, path, section_name)
    nav_link(label,
             path,
             css_class: "section-#{section_name}",
             match_prefix: true)
  end

  def nav_link(label, path, css_class: nil, match_prefix: false)
    if match_prefix
      prefix_matches = request.fullpath =~ /^#{Regexp.escape(path)}/
      selected = current_page?(path) || prefix_matches
    else
      selected = current_page?(path)
    end

    styles = [css_class]
    styles << 'selected' if selected

    content_tag(:li, class: styles.compact.join(' ')) do
      link_to label, path
    end
  end
end
