class VersionHistoryChangePresenter
  def initialize(field, old_value, new_value)
    @field = field
    @old_value = old_value
    @new_value = new_value
  end

  def field_name
    field.humanize
  end

  def formatted_old_value
    format_value(old_value)
  end

  def formatted_new_value
    format_value(new_value)
  end

  def diff
    options = { include_plus_and_minus_in_html: true }
    Diffy::Diff.new(formatted_old_value, formatted_new_value, options)
      .to_s(:html_simple)
      .html_safe
  end

  private

  attr_reader :field, :old_value, :new_value

  def format_value(value)
    if value.is_a?(Array)
      value.map do |item|
        "* #{item}\n"
      end.join
    else
      value
    end
  end
end
