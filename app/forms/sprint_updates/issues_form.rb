class SprintUpdates::IssuesForm < BaseForm
  collection :issues, populator: :populate_issues! do
    property :description
    property :treatment
    property :help
    property :identifier
    property :_destroy, virtual: true, writeable: false

    validation do
      params do
        required(:description).filled
        optional(:identifier).maybe(:integer)
      end
    end
  end

  def started?
    issues.reject { |issue|
      issue.to_nested_hash.compact.empty?
    }.any?
  end

  def prepopulate!
    self.issues << model.issues.build if self.issues.empty?
  end

  def populate_issues!(fragment:, collection:, **)
    item = issues.find { |issue| issue.id == fragment["id"].to_i }
    fields = %w{description treatment help identifier}

    if fragment['_destroy'] == '1'
      issues.delete(item)
      return skip!
    end

    completed_fields = fragment.slice(*fields).values.reject(&:blank?)
    if completed_fields.empty?
      return skip!
    end

    return item if item.present?

    issues.append(
      Issue.new(fragment.slice(*fields))
    )
  end
end
