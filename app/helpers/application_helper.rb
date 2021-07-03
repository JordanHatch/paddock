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

end
