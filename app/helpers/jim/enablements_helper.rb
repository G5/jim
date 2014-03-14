module Jim::EnablementsHelper
  def list_item(item)
    status = item.enabled?
    content_tag(
      :li,
      class: [
        "list-group-item",
        status ? "list-group-item-success" : "list-group-item-danger"
      ]
    ) do
      yield
    end
  end

  def environment_value(environment)
    redact = environment.redact_value

    content_tag(
      :span,
      class: redact ? "redacted" : nil
    ) do
      redact ? "redacted" : environment.value
    end
  end
end
