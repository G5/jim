module Jim::EnablementsHelper
  def redgreen_css_for(object, base)
    suffix = object.enabled? ? "success" : "danger"
    "#{base}-#{suffix}"
  end

  def enablement_label(object)
    css_class = redgreen_css_for(object, :label)
    text = object.enabled? ? "enabled" : "disabled"

    content_tag(:span, class: [ "label", css_class ] ) do
      text
    end
  end

  def enablements_badge(feature)
    content_tag(:span, class: "badge") do
      total = feature.enablements.length
      enabled = feature.enablements.count { |f| f.enabled? }

      if total == enabled
        total.to_s
      else
        "#{enabled}/#{total}"
      end
    end
  end

  def environment_value(environment)
    css_class = nil
    text = environment.value
    tag = :code

    if environment.is_set? && environment.redact_value
      css_class = text = "redacted"
    elsif text.blank?
      text = "unset or blank"
      tag = :em
    end

    content_tag(tag, class: css_class ) do
      text
    end
  end

  def enablements_list_item(enablement, &block)
    markup = capture(&block)
    render(
      "jim/enablements/enablement_row_item",
      row_markup: markup,
      enablement: enablement
    )
  end
end
