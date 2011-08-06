module DeviceHelpers
  
  def device_vendor_choices
    Factory(:device_vendor_choice, {:value => "Apple (Intel)", :sort_order => 0})
    Factory(:device_vendor_choice, {:value => "Dell", :sort_order => 1})
    Factory(:device_vendor_choice, {:value => "Lenovo", :sort_order => 2})
  end
  
  def device_kind_choices
    Factory(:device_kind_choice, {:value => "Computer", :sort_order => 0})
    Factory(:device_kind_choice, {:value => "Laptop", :sort_order => 1})
  end
  
  def device_mobile_vendor_choices
    Factory(:device_mobile_vendor_choice, {:value => "Apple", :sort_order => 0})
    Factory(:device_mobile_vendor_choice, {:value => "Android", :sort_order => 1})
  end
  
  def device_mobile_kind_choices
    Factory(:device_mobile_kind_choice, {:value => "Phone", :sort_order => 0})
    Factory(:device_mobile_kind_choice, {:value => "Tablet", :sort_order => 1})
  end
  
end
