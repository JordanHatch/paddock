class Manage::SprintForm < BaseForm
  property :name
  property :short_label
  property :start_on, multi_params: true, prepopulator: :prepopulate_start_on!
  property :end_on, multi_params: true, prepopulator: :prepopulate_end_on!

  def prepopulate!
    if start_on.blank?
      last_sprint = Sprint.in_reverse_date_order.first

      if last_sprint.present?
        self.start_on = last_sprint.end_on + 1.day
        self.end_on = start_on + 13.days if end_on.blank?
      end
    end
  end

  validation do
    params do
      required(:name).filled(:string)
      required(:short_label).value(:filled?, max_size?: 3)
      required(:start_on).filled(:date)
      required(:end_on).filled(:date)
    end

    rule(:end_on, :start_on) do
      key.failure('must be after the start date') if values[:end_on] < values[:start_on]
    end
  end
end
