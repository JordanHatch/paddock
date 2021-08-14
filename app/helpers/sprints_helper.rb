module SprintsHelper
  def delivery_status_text(update)
    if update.delivery_status.present?
      update.delivery_status_text
    else
      '&mdash;'.html_safe
    end
  end

  def okr_status_text(update)
    if update.okr_status.present?
      update.okr_status_text
    else
      '&mdash;'.html_safe
    end
  end
end
