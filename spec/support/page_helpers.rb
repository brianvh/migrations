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
        has_content?(user.name) } }
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

  def have_device(device)
    PageMatch.match do |m|
      m.have "#{device.device_name} as a listed device"
      m.page { within("#devices") {
        has_selector?("#device-#{device.id}") } }
    end
  end

  def have_error_message(msg)
    PageMatch.match do |m|
      m.have "'#{msg}' shown as an error"
      m.page { within(".error_messages") {
        has_content?(msg) } }
    end
  end

  def have_group(group)
    PageMatch.match do |m|
      m.have %("#{group.name}" as a listed group)
      m.page { within("#groups") {
        has_selector?("#group-#{group.id}") } }
    end
  end

  def have_group_name(name)
    PageMatch.match do |m|
      m.have %("#{name}" as its group name)
      m.page { within("#group-name") { has_content?(name) } }
    end
  end

  def have_profile_info
    PageMatch.match do |m|
      m.have %(a submitted profile)
      m.page { within("#profile-info-nav") {
        has_link?('Full Migration Profile') } }
    end
  end

  def have_devices_list
    PageMatch.match do |m|
      m.have %(listed devices)
      m.page { within("#devices") {
        has_no_content?('No devices listed.') } }
    end
  end

  def have_resources_list
    PageMatch.match do |m|
      m.have "listed resources"
      m.page { within("#resources") {
        has_no_content?('No calendar resources currently owned by you.')
        }
      }
    end
  end

  def have_resource(resource)
    PageMatch.match do |m|
      m.have %("#{resource.name}" as a listed resource)
      m.page { within("#resources") {
        has_selector?("#resource-#{resource.id}") } }
    end
  end

end
