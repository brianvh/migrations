class Resource < ActiveRecord::Base
	belongs_to :group
	has_many :ownerships
  has_many :owners, :through => :ownerships, :source => :user
end
