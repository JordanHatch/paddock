class BaseFlow
  class FormNotFound < StandardError; end

  attr_reader :current_form_id

  def initialize(current_form_id:, object:)
    @current_form_id = format_form_id(
      current_form_id || default_form_id,
    )
    @object = object
  end

  def forms
    raise StandardError, 'Override "forms" in a subclass of BaseFlow'
  end

  def form_keys
    forms.keys
  end

  def next_form_id
    return nil if last_form?

    i = form_keys.index(current_form_id) + 1
    form_keys[i]
  end

  def last_form?
    current_form_id == form_keys.last
  end

  def form_class
    if form_keys.include?(current_form_id)
      forms[current_form_id]
    else
      (raise FormNotFound, "Form \"#{current_form_id}\" not found")
    end
  end

  def completion_status_for_form(id)
    form_status[id][:completion]
  end

  def valid?
    form_status.all? { |_, status| status[:validation] == :valid }
  end

  private

  attr_reader :object

  def form_status
    @form_status ||= forms.transform_values do |klass|
      klass.from_model(object).status
    end
  end

  def format_form_id(id)
    id.to_sym
  end
end
