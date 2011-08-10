module ApplicationHelper
  def logout_link
    current_user.nil? ? "" : link_to("Logout #{current_user.name}", logout_path)
  end
end
