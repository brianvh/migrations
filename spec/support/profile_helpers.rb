module ProfileHelpers
  
  def email_client_choices
    Factory(:email_client_choice, {:label => "Blitz(mail)", :value => "blitz", :sort_order => 0})
    Factory(:email_client_choice, {:label => "GMail", :value => "gmail", :sort_order => 1})
  end
  
end