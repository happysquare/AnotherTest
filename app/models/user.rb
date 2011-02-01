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
  
  #class/static method to authenticate any user.
  def self.authenticate?(email,password)
    u = find_by_email(email)
    return true if u && u.has_password?(password)
  end
    
  
  def has_password?(pass)
    encrypt(pass) == self.encrypted_password
  end
  
  private
  
  def encrypt_password
        self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    #create an encrypted string
    Digest::SHA2.hexdigest(string)
  end

  
  
end
