class Webmaster < User
  def is_admin?
    true
  end

  def is_webmaster?
    true
  end
end
