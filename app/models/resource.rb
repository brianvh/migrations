class Resource < ActiveRecord::Base
	belongs_to :group
	has_many :ownerships
  has_many :owners, :through => :ownerships, :source => :user
  
  validates_presence_of :name, :message => "can't be blank"
  
end
