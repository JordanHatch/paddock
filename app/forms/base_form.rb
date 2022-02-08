class BaseForm < Reform::Form
  extend Forwardable
  include BaseForm::Status

  feature Reform::Form::MultiParameterAttributes

  def form_id
    basename.underscore
  end

  def template_name
    basename.underscore
  end

  private

  def basename
    self.class.name.demodulize
  end
end
