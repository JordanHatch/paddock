module ApplicationHelper
  def render_markdown(string)
    MarkdownParser.render(string)
  end

  def paddock_env
    ENV['PADDOCK_ENV']
  end

  def display_paddock_env?
    paddock_env.present? && paddock_env != 'production'
  end
end
