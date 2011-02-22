require 'spec_helper'

describe Micropost do
  before(:each) do
    @att = {:content => "this is a test micropost"}
    @user = Factory(:user)
  end
  
  it "should create a new instance with the correct parameters" do
    lambda do
      @user.microposts.create! @att
    end.should change(Micropost, :count).by(1)
  end
  
  describe "user assosiations" do
    before(:each) do
      @micropost =  @user.microposts.create! @att
    end
    it "should respond to user" do
      @micropost.should respond_to(:user)
    end
    it "the user association should be correct" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
  
  describe "posts order" do
    before(:each) do
      
      @p2 = Factory(:micropost, :user => @user, :created_at => 2.days.ago)
      @p1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      
      @posts = @user.microposts
      
    end
    
    it "should be saved in the correct order" do
      @posts.should == [@p1,@p2]
    end
    
  end
  
  describe "post dependencies" do 
    it "should delete all posts when the user is deleted" do
      p2 = Factory(:micropost, :user => @user, :created_at => 2.days.ago)
      p1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @user.destroy
      Micropost.find_by_id(p1.id).should be_nil
      Micropost.find_by_id(p2.id).should be_nil
    end
  end
  describe "validations" do
    it "should require a user" do
      Micropost.create({:content => "test"}).should_not be_valid
    end
    it "should require content" do 
      @user.microposts.create({:content => ""}).should_not be_valid
    end
    it "should not allow posts above 140 chars" do
       @user.microposts.create({:content => "a" * 141}).should_not be_valid
    end
  end
  describe "from users followed by" do
    before(:each) do
      @followed = Factory(:user, :email => Factory.next(:email))
      @not_followed = Factory(:user, :email => Factory.next(:email))
      @user_post = @user.microposts.create!(:content => "valid")
      @post = @followed.microposts.create!(:content => "valid")
      @other_post = @not_followed.microposts.create!(:content => "invalid")
      @user.follow!(@followed)
    end
    it "should have a from_users_followed_by method" do
      Micropost.should respond_to(:from_users_followed_by)
    end
    it "should include the following users' microposts" do
      Micropost.from_users_followed_by(@user).should include(@post)
    end
    it "should not include an unfollowed users microposts" do
      Micropost.from_users_followed_by(@user).should_not include(@other_post)
    end
    it "should include the users own posts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end
  end
end
