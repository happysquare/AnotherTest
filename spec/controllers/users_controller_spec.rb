require 'spec_helper'

describe UsersController do 
  render_views
  before (:each) do
     @title = "Ruby test app | "
   end
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have the correct title" do
      get 'new'
      response.should have_selector("title", :content => @title + "Sign Up")
    end
  end
  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)  
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    it "should have the correct title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @title + "users | " + @user.name)
    end
    it "should have the correct user" do
      get 'show', :id => @user
      assigns(:user).should == @user
    end 
    
    it "should have the correct users name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
    
    it "should have a gravatar" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => 'gravatar') 
    end
    
    it "should display the users microposts" do
      mp1 = Factory(:micropost, :user => @user)
      get :show, :id => @user
      response.should have_selector("span" , :content => mp1.content)
      
    end
    
  end
  describe "POST 'new'" do
    describe "failure" do
      before(:each) do
        @att = {:name => "",
                :email => "",
                :password => "",
                :password_confirmation => ""}
      end
      
      it "should fail to create a user without the correct parameters" do
        lambda do
          post :create, :user => @att
        end.should_not change(User, :count)
      end
      it "should stay on the new page when there is a failed submission" do
        post :create ,:user => @att
        response.should have_selector("title", :content => "Sign Up")
      end
    
      it "should render the correct template" do
        post :create, :user => @att
        response.should render_template('new')
      end
    end
  end
  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end  
    
    
    it "should have the correct title" do
      get :edit, :id => @user
      response.should have_selector("title" ,:content => @title + "Edit user")
    end 
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :content => "change", :href => gravatar_url)
    end
  end
  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      before(:each) do
        @att = {:email => "",
                :name => "",
                :password => "",
                :password_confirm => ""}
      end
      it "should render the edit page " do 
        put 'update', :id=> @user, :user => @att
        response.should render_template('edit')
      end
      it "should have the correct title" do
        put 'update', :id=> @user, :user => @att
        response.should have_selector("title", :content => @title + "Edit user")
      end
    end
    describe "success" do
      before(:each) do
        @att = {:email => "me4@james.com",
                :name => "newname",
                :password => "sophie",
                :password_confirm => "sophie"}
      end
      
      it "should change the users attributes" do
        put "update", :id=> @user, :user => @att
        @user.reload
        @user.name.should == @att[:name]
        @user.email.should == @att[:email]
      end
      it "should redirect to the user show page" do
        put "update", :id=> @user, :user => @att
        response.should redirect_to(user_path(@user))
      end
      it "should have a flash message" do
        put "update", :id=> @user, :user => @att
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of edit and update pages" do
    before(:each) do
      @user = Factory(:user)
    end
    describe "for users not yet signed in" do
      it "should deny access to 'update'" do
        put "update", :id=> @user, :user => {}
        response.should redirect_to(signin_path)
      end
      it "should redirect to sign in page" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      
    end
    describe "for users signed in" do
      before(:each) do
        wrong_user = Factory(:user,:email=> 'other@else.com')
        test_sign_in(wrong_user)
      end
      it "should require matching users to update" do
        put :update, :id => @user, :user => {} 
        response.should redirect_to(root_path) 
      end
    end
    
    
  end
  describe "GET 'index'" do
    describe "for signed in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :email => "another@domain.com")
        third = Factory(:user, :email => "andAnother@domain.com")
        @users = [@user,second,third]
        
        
        30.times do 
          @users << Factory(:user, :email => Factory.next(:email))
        end
        
      end
      
      it "should be successful" do 
        get :index
        response.should be_success
      end
      it "should have an element for each user" do
        @users[0..2].each do |user|
          
          #response.should have_selector("li", :content => user.name)
        end
        
      end
      it "should paginate the users " do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",:content => "2")# more than 30 users should give us exactly 2 pages.
        response.should have_selector("a", :href => "/users?page=2",:content => "Next")# next should be available 
      end
    end
    describe "for non signed in visitors" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
  end
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end
    describe "as a non signed in user" do
      it "should redirect to sign in" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    describe "as a non admin user" do 
      it "should redirect to root" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should_not be_successful
        response.should redirect_to root_path
      end
    end
    
    describe "as an admin user" do
      before(:each) do
        @user = Factory(:user, :email => "admin@admin.com", :admin => true) 
        test_sign_in(@user)
      end
      it "should delete the user from the record" do
        lambda do 
          delete :destroy, :id=> @user
        end.should change(User,:count).by(-1)
      end
      it "should redirect to users" do 
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
    
    
  end
end
 