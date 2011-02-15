# == Schema Information
# Schema version: 20110128145203
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  has_many :microposts, :dependent => :destroy
  
  email_regex = /\A([\w\.\-\+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  validates :name, :presence => true, 
            :length => {:maximum => 50, :minimum => 3}
  
  validates :email, :presence => true,
            :format => {:with => email_regex},
            :uniqueness => {:case_sensitive => false}
  
  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 5..20}
  
  before_save :encrypt_password
  
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  #class/static method to authenticate any user.
  def self.authenticate(email,sp)
    u = find_by_email(email)
    return nil if u.nil?
    return u if u.has_password?(sp)
  end
    
  def self.authenticate_and_retrieve(email,p)
     u = find_by_email(email)
     return u  if u && u.has_password?(p)
  end 
  
  def self.authenticate_with_salt(id,cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_password?(pass)
    encrypted_password == encrypt(pass)
  end
  
  
  
  def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    #create an encrypted string
   secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  def secure_hash(string)
     Digest::SHA2.hexdigest(string)
  end
  
end
