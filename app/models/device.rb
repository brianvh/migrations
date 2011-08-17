class Device < ActiveRecord::Base
  
  belongs_to :user

  attr_writer :vendor_other, :kind_other, :os_version_other, :office_version_other
  attr_writer :current_email_other, :current_browser_other, :new_email_other
  attr_writer :carrier_other

  attr_accessible :vendor, :kind, :type, :os_version, :office_version,
                  :current_email, :current_browser, :new_email, :user_id,
                  :carrier, :contacts_count,
                  :vendor_other, :kind_other, :os_version_other, :office_version_other,
                  :current_email_other, :current_browser_other, :new_email_other, :carrier_other,
                  :mobile_vendor_choice, :mobile_kind_choice, :carrier_choice, :new_email_choice,
                  :current_browser_choice, :current_email_choice, :office_version_choice,
                  :os_version_choice, :vendor_choice, :kind_choice

  validates_presence_of :vendor_choice, :message => "can't be blank"
  validates_presence_of :vendor, :message => "can't be blank"
  validates_presence_of :kind_choice, :message => "can't be blank"
  validates_presence_of :kind, :message => "can't be blank"
  
  def initialize(attrs)
    @vendor_other = attrs[:vendor_other]
    @kind_other = attrs[:kind_other]
    @os_version_other = attrs[:os_version_other]
    @office_version_other = attrs[:office_version_other]
    @current_email_other = attrs[:current_email_other]
    @current_browser_other = attrs[:current_browser_other]
    @new_email_other = attrs[:new_email_other]
    @carrier_other = attrs[:carrier_other]
    
    super
    
  end
  
  def self.new_from_type(type, attribs={})
    return nil unless [:computer, :mobile].include?(type)
    type.to_s.titlecase.constantize.send(:new, attribs)
  end

  def device_name
    "#{vendor} #{kind}"
  end

  def type_name
    self[:type].downcase
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

  def carrier_choice
    return carrier if CarrierChoice.to_options_array.include?(carrier)
    return "Other" unless carrier.blank?
    nil
  end

  def carrier_choice=(val)
    if val == "Other"
      self.carrier = @carrier_other
    else
      self.carrier = val
    end
  end

  def carrier_other
    return "" if CarrierChoice.to_options_array.include?(carrier)
    carrier
  end

end
