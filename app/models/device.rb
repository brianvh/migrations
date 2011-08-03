class Device < ActiveRecord::Base
  
  belongs_to :user

  attr_writer :vendor_other

  def vendor_choice # okay
    return vendor if DeviceVendorChoice.to_options_array.include?(vendor)
    "Other"
  end
    
  def vendor_choice=(val)
    if val == "Other"
      self.vendor = @vendor_other
    else
      self.vendor = val
    end
  end

  def vendor_other # okay
    return "" if DeviceVendorChoice.to_options_array.include?(vendor)
    vendor
  end
  
end
