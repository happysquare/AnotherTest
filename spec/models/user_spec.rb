require 'spec_helper'

describe User do
 before(:each) do
   @user_att = {
                :name => 'james johnston', 
                :email=> "james@happysquare.com.au",
                :password=> "soph22",
                :password_confirmation => "soph22"
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
      User.authenticate( @user_att[:email], @user_att[:password]).should be_true
    end
    it "should not authenticate false password" do
      User.authenticate( @user_att[:email], "notpassword").should be_false
    end
    it "should not authenticate non existent email" do
      User.authenticate( "not.any@user.com", @user_att[:password]).should be_false
    end

  end
  
 describe "admin settings" do
   before(:each) do
     @user = User.create(@user_att)
   end
   it "should respond to admin" do
     @user.should respond_to(:admin)
   end
   it "should not be an admin by default" do 
     @user.should_not be_admin
   end
   it "should be convertible to an admin" do 
     @user.toggle! :admin
     @user.should be_admin
   end
 end
 describe "associations" do
   describe "microposts" do
     before(:each) do
       @user = User.create(@user_att)
       @micropost = @user.microposts.create({:content => "test micropost"})
     end
     it "should be respond to microposts" do
       @user.should respond_to(:microposts)
     end
   end
 end

  describe "micropost associations" do
   before(:each) do
     @user = User.create(@user_att)
     @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
     @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
   end

   describe "status feed" do
     it "should have a feed" do
       @user.should respond_to(:feed)
     end
     it "should include the users microposts" do
       @user.feed.include?(@mp1).should be_true
       @user.feed.include?(@mp2).should be_true
     end
     it "should not include a different user's microposts" do
       mp3 = Factory(:micropost,
                      :user => Factory(:user,:email => Factory.next(:email)))
      @user.feed.include?(mp3).should be_false
     end
     it "should include microposts of followed users" do
       followed = Factory(:user, :email => Factory.next(:email))
       post = followed.microposts.create!(:content => "hallo")
       @user.follow!(followed)
       @user.feed.should include(post)
     end
   end
  end
  describe "relationships" do
     before(:each) do
       @user = User.create(@user_att)
       @followed = Factory(:user)
     end
     it "should have a relationships method" do
       
       @user.should respond_to(:relationships)
     end
     it "should have the following method" do
       @user.should respond_to(:following)
     end
     
     it "should have a following? method" do
       @user.should respond_to(:following?)
     end
     it "should have a follow! method" do
        @user.should respond_to(:follow!)
      end
      it "should have an unfollow! method" do
          @user.should respond_to(:unfollow!)
        end
     it "should follow another user" do
       @user.follow!(@followed)
       @user.should be_following(@followed)
     end
     it "should include the followed user in the following array" do
       @user.follow!(@followed)
       @user.following.should include(@followed)
     end
     it "should remove the followed user in the following array" do
        @user.follow!(@followed)
        @user.unfollow!(@followed)
        @user.following.should_not include(@followed)
      end
     
  end
 
end
