class VersionHistoryItemPresenter
  include ActionView::Helpers::DateHelper
  extend Forwardable

  def_delegators :version, :created_at, :changeset

  STATE_FIELD = 'state'.freeze

  def initialize(version)
    @version = version
  end

  def author_email
    author.email if author.present?
  end

  def time_ago
    time_ago_in_words(version.created_at)
  end

  def changes
    changeset.map do |field, (previous, current)|
      VersionHistoryChangePresenter.new(field, previous, current)
    end
  end

  def changed_fields
    changeset.keys
  end

  def state_change?
    changed_fields.include?(STATE_FIELD)
  end

  def new_state
    if state_change?
      _, new_value = changeset[STATE_FIELD]
      new_value
    end
  end

  def diff(old_value, new_value)
    Diffy::Diff.new(old_value, new_value)
               .to_s(:html_simple)
               .html_safe
  end

  private

  attr_reader :version

  def author
    User.where(id: version.whodunnit).first if version.whodunnit.present?
  end
end
