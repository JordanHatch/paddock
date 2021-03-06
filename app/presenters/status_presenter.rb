class StatusPresenter
  attr_reader :key

  include ActionView::Helpers::TagHelper

  def initialize(key)
    @key = key.to_sym
  end

  def all
    values.map do |v|
      [format_label(v), v]
    end
  end

  def format_label(label)
    [
      content_tag(
        :div,
        I18n.t(:label, scope: [:updates, key, label]),
      ),
      content_tag(
        :div,
        I18n.t(:hint_text, scope: [:updates, key, label]),
        class: 'radio-button__subtitle',
      ),
    ].join.html_safe
  end

  def values
    Update.send(key).values
  end
end
