module PageHelpers

  def have_header(selector, text)
    PageMatch.match do |m|
      m.have %(a main header of "#{text}")
      m.page { within("##{selector}-header") { has_content?(text) } }
    end
  end

  def have_logout_link(user)
    PageMatch.match do |m|
      m.have %(a logout link for "#{user.name}")
      m.page { within("#logout") {
        has_selector?(:xpath, %(.//a), :text => user.name) } }
    end
  end

end