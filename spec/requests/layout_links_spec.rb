require 'spec_helper'

describe "LayoutLinks" do
  
  
  it "should have a homepage link at '/'" do
    get '/'
    response.should have_selector('title', :content =>"Home")
  end
  
  it "should have a homepage link at 'contact'" do
    get '/contact'
    response.should have_selector('title', :content =>"Contact")
  end
  
  it "should have a homepage link at '/about'" do
    get '/about'
    response.should have_selector('title', :content =>"About")
  end
  
  it "should have a homepage link at '/help'" do
    get '/help'  
    response.should have_selector('title', :content =>"Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign Up")
  end
  
  it "should have the right links on the layout " do
    visit root_path
    click_link "About"
    response.should have_selector('title', :content => "About")
    click_link "Help"
    response.should have_selector('title', :content => "Help")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact")
  end
  
  describe "when not signed in" do
    it "should have a sign in link" do
      visit root_path
      response.should have_selector("a", :href => signin_path, :content => "Sign in")
    end
  end
  describe "when signed in" do
    before(:each) do
      visit signin_path
      @user = Factory(:user)
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
      
    end
    it "should have a sign out link" do
      visit root_path
      response.should have_selector("a", :href => signout_path, :content => "Sign out")
    end
    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user), :content=> "Profile")
    end
    
  end
  
end 
