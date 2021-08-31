class SprintUpdates::IssuesForm < BaseForm
  class Issue < BaseForm
    attribute? :id, Types::Nominal::Integer
    attribute? :description, Types::Nominal::String
    attribute? :treatment, Types::Nominal::String
    attribute? :help, Types::Nominal::String
    attribute? :identifier, Types::Nominal::Nil | Types::Nominal::Integer
    attribute? :_destroy, Types::Nominal::Integer

    def persisted?
      id.present?
    end

    validation do
      params do
        required(:description).filled(:string)
        optional(:identifier).maybe(:integer)
      end
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

  before_validate do |form, atts|
    atts[:issues_attributes].reject! {|obj| if_all_blank?(obj) }
    form.issues_attributes.reject! {|obj| if_all_blank?(obj) }
  end

  validation do
    params do
      optional(:issues_attributes).value(:array)
    end
  end

  def started?
    issues_attributes.reject { |issue|
      issue.attributes.compact.empty?
    }.any?
  end

  private

  def self.if_all_blank?(obj)
    atts = obj.to_hash
    atts.reject { |_key, value| value.blank? }.empty?
  end
end
