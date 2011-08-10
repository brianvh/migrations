module ResourcesHelper

  def boolean_display(val)
    return "Not yet specified" if val.nil?
    val ? "Yes" : "No"
  end

end
