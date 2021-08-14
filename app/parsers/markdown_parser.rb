class MarkdownParser
  def self.render(string)
    new.render(string)
  end

  def render(string)
    string.then(&method(:pad_headings))
          .then(&method(:render_markdown))
  end

  private

  def renderer
    @renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        escape_html: true,
        hard_wrap: true,
      ),
      autolink: true,
      tables: true,
      lax_spacing: true,
    )
  end

  def render_markdown(string)
    renderer.render(string)
  end

  # Pad the heading tags to be at least <h4> so that it doesn't
  # break the structure of the page (and PDF)
  #
  def pad_headings(string)
    string.gsub(/^(\#{1,3})( |\w)/) do |_|
      "#{Regexp.last_match(1)}####{Regexp.last_match(2)}"
    end
  end
end
