class Admin < User
  def is_support?
    true
  end

  def is_admin?
    true
  end
end
