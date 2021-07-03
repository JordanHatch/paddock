class StatusPresenter
  attr_reader :key
  include ActionView::Helpers::TagHelper

  def initialize(key)
    @key = key.to_sym
  end

  def all
    values.map {|v|
      [format_label(v), v]
    }
  end

  def format_label(label)
    [
      I18n.t(:label, scope: [:updates, key, label]),
      content_tag(
        :span,
        I18n.t(:hint_text, scope: [:updates, key, label])
      )
    ].join.html_safe
  end

  def values
    Update.send(key).values
  end

end
