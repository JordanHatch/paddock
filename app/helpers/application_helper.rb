module ApplicationHelper

  def render_markdown(string)
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        escape_html: true,
        hard_wrap: true,
      ),
      autolink: true,
      tables: true,
      lax_spacing: true,
    ).render(string || '')
  end

  def sprint_navigation_link(target_sprint)
    if controller_name == 'updates'
      update_path(target_sprint, params[:team_id])
    else
      sprint_path(target_sprint)
    end
  end

  def nav_link(label, link, identifier)
    selected_section = content_for(:selected_section)
    selected = selected_section.to_s == identifier.to_s

    styles = ["section-#{identifier}"]
    styles << 'selected' if selected

    content_tag :li, { class: styles.join(' ') } do
      link_to label, link
    end
  end

end
