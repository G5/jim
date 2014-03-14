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
end
