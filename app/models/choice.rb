class Choice < ActiveRecord::Base
  default_scope :order => "sort_order"

  def self.to_options_array
    all.collect { |choice| choice.value } << "Other"
  end

end
