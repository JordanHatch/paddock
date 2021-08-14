class SprintUpdates::IssuesForm < BaseForm
  class Issue < BaseForm
    attribute? :id, Types::Nominal::Integer
    attribute? :description, Types::Nominal::String
    attribute? :treatment, Types::Nominal::String
    attribute? :help, Types::Nominal::String
    attribute? :identifier, Types::Nominal::String
    attribute? :_destroy, Types::Nominal::Integer

    def persisted?
      id.present?
    end
  end

  def issues
    issues_attributes
  end

  nested_attributes :issues

  attribute? :issues_attributes, Types::Array.of(Issue).default([], shared: true)

  preprocess do |form|
    form.issues_attributes << Issue.new if form.issues_attributes.empty?
  end

  before_validate do |_form, atts|
    atts[:issues_attributes].reject! do |obj|
      atts = obj.to_hash
      atts.reject { |_key, value| value.blank? }.empty?
    end
  end

  validation do
    params do
      optional(:issues_attributes).value(:array, size?: 0..5).each do
        schema do
          required(:description).filled(:string)
        end
      end
    end
  end

  def started?
    issues_attributes.reject { |issue|
      issue.attributes.compact.empty?
    }.any?
  end
end
