require 'spec_helper'

describe User do
 before(:each) do
   @user_att = {:name => "James", :email=> "james@happysquare.com.au"}
 end
 it "should create a new user" do
   User.create(@user_att)
 end
   
 it "should require a name" do
   no_name_user = User.create(@user_att.merge(:name => nil))
   no_name_user.should_not be_valid
 end
 it "should require an email" do
   no_email_user = User.create(@user_att.merge(:name => nil))
   no_email_user.should_not be_valid
 end
 it "should require a valid name" do
  
   names = ["a" * 51,"h","hi"]
   names.each do |n|
     u = User.create(@user_att.merge(:name => n))
     u.should_not be_valid 
   end
 end
 it "should require a valid email" do
   emails = %w[thist.com t.t.com this@that,com]
   emails.each do |e|
     u = User.create(@user_att.merge(:email => e))
     u.should_not be_valid
   end
 end
 
 it "should not allow dulplicate emails" do 
   User.create!(@user_att)
   u = User.create(@user_att)
   u.should_not be_valid
 end

end
