module DeviceHelpers
  
  def device_vendor_choices
    Factory(:device_vendor_choice, {:value => "Apple (Intel)", :sort_order => 0})
    Factory(:device_vendor_choice, {:value => "Dell", :sort_order => 1})
  end
  
  
end
