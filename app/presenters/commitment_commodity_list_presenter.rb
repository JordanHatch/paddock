class CommitmentCommodityListPresenter
  VALUES = Commitment.commodities.values
  extend ActionView::Helpers::TagHelper

  def self.all
    VALUES.map do |v|
      [format_label(v), v]
    end
  end

  def self.format_label(key)
    label = I18n.t(key, scope: [:commitments, :commodities], default: '')

    content_tag(:div, label).html_safe
  end
end
