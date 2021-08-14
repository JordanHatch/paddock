class Manage::SprintForm < BaseForm
  attribute :name, Types::Nominal::String
  attribute :start_on, Types::Nominal::Date
  attribute :end_on, Types::Nominal::Date

  preprocess do |form|
    if form.start_on.blank?
      last_sprint = Sprint.in_reverse_date_order.first

      if last_sprint.present?
        form.attributes[:start_on] = last_sprint.end_on + 1.day

        form.attributes[:end_on] = form.start_on + 13.days if form.end_on.blank?
      end
    end
  end

  validation do
    params do
      required(:name).filled(:string)
      required(:start_on).filled(:date)
      required(:end_on).filled(:date)
    end

    rule(:end_on, :start_on) do
      key.failure('must be after the start date') if values[:end_on] < values[:start_on]
    end
  end
end
