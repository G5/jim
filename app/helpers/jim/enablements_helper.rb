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

      if feature.enabled?
        total.to_s
      else
        enabled = feature.enablements.count { |f| f.enabled? }
        "#{enabled}/#{total}"
      end
    end
  end

  def environment_value(environment)
    css_class = environment.redact_value ? "redacted" : nil
    text = environment.redact_value ? "redacted" : environment.value
    tag = :code

    if text.blank?
      tag = :em
      text = "unset or blank"
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
