require 'spec_helper'

describe "Users" do
  describe "signup" do
    
    describe "failure" do
      it "should fail to create a new user" do
        lambda do
          visit signup_path
          fill_in "user_name", :with => ""
          fill_in "user_email", :with => ""
          fill_in "user_password", :with => ""
          fill_in "user_password_confirmation", :with => ""
      
          click_button
      
          response.should render_template('new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
     end
    end
    describe "success" do
      it "should successfully create a user and flash message" do
        lambda do
          visit signup_path
          fill_in "user_name", :with => "jimmy"
          fill_in "user_email", :with => "jimmy@jimmy.com"
          fill_in "user_password", :with => "password"
          fill_in "user_password_confirmation", :with => "password"
      
          click_button
      
          response.should render_template('show')
          response.should have_selector('div.flash.success',:content => 'Welcome')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "signing in and out" do
    describe "sign in failure" do
      it "should fail to sign in " do
        visit signin_path
        fill_in "email", :with => ""
        fill_in "password", :with => ""
        click_button
        response.should have_selector("div.flash.error" ,:content => "Invalid login" )
      end
    end
    describe "sign in and out" do
      it "should sign the user in successfully then sign them out again" do
        user = Factory(:user) 
        visit signin_path
        fill_in :email, :with => user.email
        fill_in :password, :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end  
  end
end
