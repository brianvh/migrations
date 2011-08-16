class Support < User
  def is_support?
    true
  end

  def self.group_select_list(consultants=[])
    existing_ids = consultants.map(&:id)
    Support.all.select { |s| !existing_ids.include?(s.id) }.map { |s| [s.last_first, s.id] }
  end

end
