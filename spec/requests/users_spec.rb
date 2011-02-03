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
end
