class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  default_scope :order => 'microposts.created_at DESC'
  
  validates :user, :presence => true
  validates :content, :presence => true,
                      :length => {:within => 1..140}
  
  cattr_reader :per_page
  @@per_page = 5
  
end
