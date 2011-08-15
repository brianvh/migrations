module ApplicationHelper
  def logout_link
    current_user.nil? ? "" : link_to("Logout #{current_user.name}", logout_path, :id => "logout")
  end

  def show_div_link(label, div)
    link_to_function label, "$('#{div}').show('slow')"
  end

  def hide_div_link(label, div)
    link_to_function label, "$('#{div}').hide('slow')"
  end
end
