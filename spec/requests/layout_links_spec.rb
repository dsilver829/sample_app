require 'spec_helper'

describe "Layout Links" do

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => @base_title + "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => @base_title + "Contact")
  end
  
  it "should have a About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => @base_title + "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => @base_title + "Help")
  end

  it "should have a signup page at /signup" do
    get '/signup'
    response.should have_selector("title", :content => "Sign Up")
  end

  it "should have the right links in the layout" do
    visit root_path
    click_link "Sign up now!"
    response.should have_selector('title', :content => 'Home')
    click_link "About"
    response.should have_selector('title', :content => 'About')
    click_link "Help"
    response.should have_selector('title', :content => 'Help')
    click_link "Contact"
    response.should have_selector('title', :content => 'Contact')
    click_link "Home"
    response.should have_selector('title', :content => 'Home')
  end

  describe "when not signed in" do
    it "should have a sign in link" do
      visit root_path
      response.should have_selector("a",  :href => signin_path,
                                          :content => "Sign In")
    end
  end

  describe "when signed in" do
    before(:each) do
      @user = User.new( :name => "David Silver",
                        :email => "email@example.com",
                        :password => "valid_password",
                        :password_confirmation => "valid_password")
      @user.save
      visit signin_path
      fill_in :email,     :with => @user.email
      fill_in :password,  :with => @user.password
      click_button
    end

    it "should have a sign out link" do
      visit root_path
      response.should have_selector("a",  :href => signout_path,
                                          :content => "Sign Out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a",  :href => user_path(@user),
                                          :content => "Profile")
    end
  end
end
