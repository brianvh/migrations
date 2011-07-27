module ApplicationHelper
  def logout_link(user=nil)
    user.nil? ? "" : link_to("Logout #{user.name}", logout_path)
  end
end
