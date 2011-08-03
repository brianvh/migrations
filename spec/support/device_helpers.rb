module DeviceHelpers
  
  def device_vendor_choices
    Factory(:device_vendor_choice, {:label => "Apple", :value => "Apple", :sort_order => 0})
    Factory(:device_vendor_choice, {:label => "Dell", :value => "Dell", :sort_order => 1})
  end
  
  
end
