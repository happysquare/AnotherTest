class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  default_scope :order => 'microposts.created_at DESC'
  
  validates :user, :presence => true
  validates :content, :presence => true,
                      :length => {:within => 1..140}
  
  cattr_reader :per_page
  @@per_page = 5
  
  scope :from_users_followed_by, lambda{ |user| followed_by(user) }
  
  private
    def self.followed_by(user)
      # select from the table relationships, all records where the follower_id integer is equal to the user_id
      followed_ids = %(SELECT followed_id FROM relationships 
                        WHERE follower_id = :user_id)
 
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", {:user_id => user} )
 end
  
end
