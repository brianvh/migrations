class Mobile < Device

  def office_version
    'N/A'
  end

  def current_browser
    'N/A'
  end

  def mobile_vendor_choice
    return vendor if DeviceMobileVendorChoice.to_options_array.include?(vendor)
    return "Other" unless vendor.blank?
    nil
  end

  def mobile_vendor_choice=(val)
    if val == "Other"
      self.vendor = @vendor_other
    else
      self.vendor = val
    end
  end

  def mobile_vendor_other
    return "" if DeviceMobileVendorChoice.to_options_array.include?(vendor)
    vendor
  end

  def mobile_kind_choice
    return kind if DeviceMobileKindChoice.to_options_array.include?(kind)
    return "Other" unless kind.blank?
    nil
  end

  def mobile_kind_choice=(val)
    if val == "Other"
      self.kind = @kind_other
    else
      self.kind = val
    end
  end

  def mobile_kind_other
    return "" if DeviceMobileKindChoice.to_options_array.include?(kind)
    kind
  end

  def vendor_choice
    return vendor if DeviceMobileVendorChoice.to_options_array.include?(vendor)
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
    return "" if DeviceMobileVendorChoice.to_options_array.include?(vendor)
    vendor
  end

  def kind_choice
    return kind if DeviceMobileKindChoice.to_options_array.include?(kind)
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
    return "" if DeviceMobileKindChoice.to_options_array.include?(kind)
    kind
  end

end
