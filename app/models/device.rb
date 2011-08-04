class Device < ActiveRecord::Base
  
  belongs_to :user

  attr_writer :vendor_other, :kind_other, :os_version_other, :office_version_other
  attr_writer :current_email_other, :current_browser_other, :new_email_other
  
  def new_email_choice
    return new_email if NewEmailChoice.to_options_array.include?(new_email)
    return "Other" unless new_email.blank?
    nil
  end
  
  def new_email_choice=(val)
    if val == "Other"
      self.new_email = @new_email_other
    else
      self.new_email = val
    end
  end

  def new_email_other
    return "" if NewEmailChoice.to_options_array.include?(new_email)
    new_email
  end
  
  def current_browser_choice
    return current_browser if CurrentBrowserChoice.to_options_array.include?(current_browser)
    return "Other" unless current_browser.blank?
    nil
  end
  
  def current_browser_choice=(val)
    if val == "Other"
      self.current_browser = @current_browser_other
    else
      self.current_browser = val
    end
  end

  def current_browser_other
    return "" if CurrentBrowserChoice.to_options_array.include?(current_browser)
    current_browser
  end
  
  def current_email_choice
    return current_email if CurrentEmailChoice.to_options_array.include?(current_email)
    return "Other" unless current_email.blank?
    nil
  end
  
  def current_email_choice=(val)
    if val == "Other"
      self.current_email = @current_email_other
    else
      self.current_email = val
    end
  end

  def current_email_other
    return "" if CurrentEmailChoice.to_options_array.include?(current_email)
    current_email
  end

  def office_version_choice
    return office_version if OfficeVersionChoice.to_options_array.include?(office_version)
    return "Other" unless office_version.blank?
    nil
  end
  
  def office_version_choice=(val)
    if val == "Other"
      self.office_version = @office_version_other
    else
      self.office_version = val
    end
  end

  def office_version_other
    return "" if OfficeVersionChoice.to_options_array.include?(office_version)
    office_version
  end

  def os_version_choice
    return os_version if OsVersionChoice.to_options_array.include?(os_version)
    return "Other" unless os_version.blank?
    nil
  end

  def os_version_choice=(val)
    if val == "Other"
      self.os_version = @os_version_other
    else
      self.os_version = val
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
