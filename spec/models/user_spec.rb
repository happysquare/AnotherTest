require 'spec_helper'

describe User do
 before(:each) do
   @user_att = {
                :name => "James", 
                :email=> "james@happysquare.com.au",
                :password=> "password",
                :password_confirmation => "password"
                }
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
 
 it "should require a password" do
   u = User.create(@user_att.merge(:password => nil))
   u.should_not be_valid
 end
 
 it "should require a correct password confirmation" do
   u = User.create(@user_att.merge(:password_confirmation => "lassword"))
   u.should_not be_valid
 end
 
 it "should reject long passwords" do
   u = User.create(@user_att.merge(:password => "a"*100,:password_confirmation => "a"*100))
   u.should_not be_valid
 end
 
 it "should reject short passwords" do
   u = User.create(@user_att.merge(:password => "a",:password_confirmation => "a"))
   u.should_not be_valid
 end
 
  describe "password encryption" do

    before(:each) do
      @user = User.create(@user_att)
    end

    it "should respond to encrypted_password" do
      @user.should respond_to (:encrypted_password)
    end

    it "should set the encrypted password" do 
      @user.encrypted_password.should_not be_blank
    end

    it "should have the password " do
      @user.has_password?(@user_att[:password]).should be_true
    end

    it "should not have the wrong password " do
      @user.has_password?("not_my_password").should be_false
    end  

    it "should authenticate the user" do
      User.authenticate?( @user_att[:email], @user_att[:password]).should be_true
    end
    it "should not authenticate false password" do
      User.authenticate?( @user_att[:email], "notpassword").should be_false
    end
    it "should not authenticate non existent email" do
      User.authenticate?( "not.any@user.com", @user_att[:password]).should be_false
    end

  end
  
 

end
