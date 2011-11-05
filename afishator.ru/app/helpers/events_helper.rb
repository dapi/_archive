module EventsHelper
  def highlighted(object, hit, field)
    hl = hit.highlight(field)
    hl ? hl.format { |fragment| content_tag(:em, fragment) }.html_safe : object.send(field)
  end
end
