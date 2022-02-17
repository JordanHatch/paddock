# frozen_string_literal: true

class Common::ButtonComponent < BaseComponent
  Schemes = Types::Coercible::Symbol.enum(:default, :primary, :success, :warning, :danger)
  Sizes = Types::Coercible::Symbol.enum(:sm, :md)
  Styles = Types::Coercible::Symbol.enum(:default, :inverted)
  Tags = Types::Coercible::Symbol.enum(:button, :a)

  # Core options
  #
  option :scheme, type: Schemes, optional: true, default: -> { :default }
  option :size, type: Sizes, optional: true, default: -> { :md }
  option :style, type: Styles, optional: true, default: -> { :default }
  option :tag, type: Tags, optional: true, default: -> { :button }

  # Additional HTML attributes
  #
  option :classes, optional: true, as: :extra_classes
  option :data, optional: true
  option :href, optional: true
  option :id, optional: true
  option :title, optional: true
  option :type, optional: true

  def call
    content_tag tag, attributes do
      content
    end
  end

  private

  def base_css_class
    'button'
  end

  def css_classes
    "#{base_css_class} #{base_css_class}--#{variant} #{base_css_class}--#{size} #{extra_classes}"
  end

  def variant
    if style == :inverted
      "inverted-#{scheme}"
    else
      scheme
    end
  end

  def attributes
    base = {}.tap do |atts|
      atts[:class] = css_classes
      atts[:data] = data if data.present?
      atts[:id] = id if id.present?
      atts[:title] = title if title.present?
    end

    case tag
    when :button
      base.tap do |atts|
        atts[:type] = type if type.present?
      end
    when :a
      base.tap do |atts|
        atts[:href] = href if href.present?
      end
    end
  end
end
