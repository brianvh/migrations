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
    return "" unless (current_user.is_admin? || current_user.is_tech?)
    content_tag(:li, link_to("Migrations", migrations_path), :class => active_tab_class("migrations", "right"))
  end
  
  def add_chosen_assets
    content_for :head_css do
      stylesheet_link_tag "chosen", :cache => true
    end
    content_for :head_script do
      javascript_include_tag("chosen.jquery.min", :cache => true) + 
      %{
        <script type="text/javascript">
        $(document).ready(function() {
          $(".chzn-select").chosen()
        });
        </script>
      }.html_safe
    end
  end

  def add_form_assets
    content_for(:head_script, javascript_include_tag('form_scripts'))
  end
  
  def add_table_assets
    content_for :head_css do
      content_for(:head_css) +
      stylesheet_link_tag("datatable")
    end
    content_for :head_script do
      content_for(:head_script) +
      javascript_include_tag('jquery.dataTables.min.js') +
      %{
        <script type="text/javascript">
        $(document).ready(function() {
            $('#members-table').dataTable( {
          "bFilter": false,
          "bInfo": false,
          "bPaginate": false,
          "aaSorting": [[0,'asc'], [1,'asc']],
          "aoColumnDefs": [ 
      			  { "bSortable": false, "aTargets": [ 8 ] }
      		  ]
          });
            $('#groups-table').dataTable( {
              "bFilter": false,
              "bInfo": false,
              "bPaginate": false,
              "aoColumnDefs": [ 
          			  { "bSortable": false, "aTargets": [ 0, 1, 3, 4 ] }
          		  ]
            });
        });
        </script>
      }.html_safe
    end
  end

  def expired_warning
    content_tag(:div, content_tag(:h2, "THIS DND ENTRY HAS EXPIRED", :style => "color: red; font-weight: bold; text-align: center;"))
  end

  def unspecified_if_blank(val, red=true)
    # style = red ? "color: red;" : ""
    # return content_tag(:span, "Unspecified", :style => style) if val.nil?
    return content_tag(:span, "Unspecified", :style => "font-weight: bold;") if val.nil?
    val ? "Yes" : "No"
  end

  private
  
  def active_tab_class(controller_name, classes="")
    classes = classes.split
    active = controller.controller_name == controller_name ? "active" : ""
    (classes << active).join(" ")
  end
  
end
