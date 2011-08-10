module ProfileHelpers
  
  def email_client_choices
    Factory(:email_client_choice, {:value => "Blitz[Mail]", :sort_order => 0})
    Factory(:email_client_choice, {:value => "GMail", :sort_order => 1})
  end
  
end