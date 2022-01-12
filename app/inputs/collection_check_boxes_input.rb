class CollectionCheckBoxesInput < SimpleForm::Inputs::CollectionCheckBoxesInput
  def input_options
    super.merge(item_wrapper_tag: :div)
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.check_box +
      content_tag(:div, collection_builder.text.to_s, class: 'checkbox__label-text')
  end

  def item_wrapper_class
    'checkbox checkbox--lg'
  end
end
