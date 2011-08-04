class Device < ActiveRecord::Base
  
  belongs_to :user

  attr_writer :vendor_other
  attr_writer :kind_other
  attr_writer :os_version_other
  
  def os_version_choice
    return os_version if OsVersionChoice.to_options_array.include?(os_version)
    return "Other" unless os_version.blank?
    nil
  end

  def os_version_choice=(val)
    if val == "Other"
      self.os_version = @os_version_other
    else
      self.vendor = val
    end
  end

  def os_version_other
    return "" if OsVersionChoice.to_options_array.include?(os_version)
    os_version
  end

  def vendor_choice
    return vendor if DeviceVendorChoice.to_options_array.include?(vendor)
    return "Other" unless vendor.blank? #self.new_record?
    nil
  end
    
  def vendor_choice=(val)
    if val == "Other"
      self.vendor = @vendor_other
    else
      self.vendor = val
    end
  end

  def vendor_other
    return "" if DeviceVendorChoice.to_options_array.include?(vendor)
    vendor
  end
  
  def kind_choice
    return kind if DeviceKindChoice.to_options_array.include?(kind)
    return "Other" unless kind.blank?
    nil
  end
    
  def kind_choice=(val)
    if val == "Other"
      self.kind = @kind_other
    else
      self.kind = val
    end
  end

  def kind_other
    return "" if DeviceKindChoice.to_options_array.include?(kind)
    kind
  end
  
end
