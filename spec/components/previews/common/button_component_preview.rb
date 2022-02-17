class Common::ButtonComponentPreview < ViewComponent::Preview
  # @label Button
  #
  # @param tag select [button, a]
  # @param scheme select [default, primary, success, warning, danger]
  # @param style select [default, inverted]
  def button(content: 'Button', tag: :button, scheme: :default, style: :default)
    render(Common::ButtonComponent.new(tag: tag, scheme: scheme, style: style)) { content }
  end

  # @!group Styles

  # @label Primary
  #
  def button_primary
    render(Common::ButtonComponent.new(scheme: :primary)) { 'Primary button' }
  end

  # @label Success
  #
  def button_success
    render(Common::ButtonComponent.new(scheme: :success)) { 'Success button' }
  end

  # @label Warning
  #
  def button_warning
    render(Common::ButtonComponent.new(scheme: :warning)) { 'Warning button' }
  end

  # @label Danger
  #
  def button_danger
    render(Common::ButtonComponent.new(scheme: :danger)) { 'Danger button' }
  end

  # @label Inverted primary
  #
  def button_inverted_primary
    render(Common::ButtonComponent.new(scheme: :primary, style: :inverted)) { 'Primary inverted button' }
  end

  # @label Inverted success
  #
  def button_inverted_success
    render(Common::ButtonComponent.new(scheme: :success, style: :inverted)) { 'Success inverted button' }
  end

  # @label Inverted warning
  #
  def button_inverted_warning
    render(Common::ButtonComponent.new(scheme: :warning, style: :inverted)) { 'Warning inverted button' }
  end

  # @label Inverted danger
  #
  def button_inverted_danger
    render(Common::ButtonComponent.new(scheme: :danger, style: :inverted)) { 'Danger inverted button' }
  end

  # @!endgroup

  # @!group Links

  # @label Default link
  #
  def default_link
    render(Common::ButtonComponent.new(tag: :a, href: '#')) { 'Link button' }
  end

  # @label Link with attributes
  #
  def link_with_attributes
    render(Common::ButtonComponent.new(tag: :a, href: '#', title: 'A title', data: { example: 'value' })) do
      'Link button'
    end
  end

  # @!endgroup

  # @!group Button sizes

  # @label Small
  #
  def small
    render(Common::ButtonComponent.new(size: :sm)) { 'Button' }
  end

  # @label Medium
  #
  def medium
    render(Common::ButtonComponent.new(size: :md)) { 'Button' }
  end

  # @!endgroup
end
