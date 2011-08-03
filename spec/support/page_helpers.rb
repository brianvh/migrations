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

  def have_no_group_members
    PageMatch.match do |m|
      m.have %(no group members)
      m.page { within("#group-members") {
        has_content?('No users assigned to this group.') } }
    end
  end

  def have_group_members(num)
    PageMatch.match do |m|
      m.have %(#{num} group member#{num == 1 ? '' : 's'})
      m.page { within("#group-members") {
        has_selector?(:xpath, './/tr', :count => num+1) } }
    end
  end

  def have_group_member(user)
    PageMatch.match do |m|
      m.have %(#{user.last_first} as a group member)
      m.page { within("#group-members") {
        has_selector?("#user-#{user.id}") } }
    end
  end

end
