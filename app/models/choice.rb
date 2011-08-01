class Choice < ActiveRecord::Base
  default_scope :order => "sort_order"
end
