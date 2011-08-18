module ApplicationHelper
  def logout_link
    current_user.nil? ? "" : link_to("Logout #{current_user.name}", logout_path, :id => "logout")
  end

  def show_div_link(label, div)
    link_to_function label, "$('##{div}').show('slow')"
  end

  def hide_div_link(label, div)
    link_to_function label, "$('##{div}').hide('slow')"
  end
  
  def user_nav_tabs
    return "" if controller_path == "sessions"
    content_tag(:li, link_to("Home", root_path), :class => active_tab_class("users"))
  end
  
  def support_nav_tabs
    return "" if controller_path == "sessions"
    return "" unless current_user.is_support?
    content_tag(:li, link_to("Groups", groups_path), :class => active_tab_class("groups", "right")) +
    content_tag(:li, link_to("Resources", resources_path), :class => active_tab_class("resources", "right"))
  end
  
  def admin_nav_tabs
    return "" if controller_path == "sessions"
    return "" unless current_user.is_support?
    content_tag(:li, link_to("Migrations", '#'), :class => active_tab_class("migrations", "right"))
  end
  
  def add_chosen_assets
    content_for :head_css do
      stylesheet_link_tag "chosen", :cache => true
    end
    content_for :head_script do
      %{
        <script type="text/javascript">
        $(document).ready(function() {
          $(".chzn-select").chosen()
        });
        </script>
      }.html_safe
    end
  end

  private
  
  def active_tab_class(controller_name, classes="")
    classes = classes.split
    active = controller.controller_name == controller_name ? "active" : ""
    (classes << active).join(" ")
  end
  
end
