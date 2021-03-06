module ListsHelper

  def undefined
    @list.id.nil?
  end

  def form_action
    undefined ? "create" : "update"
  end

  def edit_url
    @list.edit_url
  end

  def default_text(text_for)
    undefined ? "" : @list[text_for]
  end

  def submit_text
    undefined ? "create" : "update"
  end

  def name_for_display(element)
    element.class.to_s.pluralize
  end

  def elements_for_list(list)
    elements = list.elements
    list.home? ? elements[1..elements.count] : list.elements
  end
end
