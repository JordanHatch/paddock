class CollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  def input_options
    super.merge(item_wrapper_tag: :div)
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.radio_button +
      content_tag(:div, collection_builder.text.to_s, class: 'radio-button__label-text')
  end

  def item_wrapper_class
    'radio-button radio-button--lg'
  end
end
