require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",              :with => ""
          fill_in "Email",             :with => ""
          fill_in "Password",          :with => ""
          fill_in "Confirmation",      :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",              :with => "Test User"
          fill_in "Email",             :with => "test@test.com"
          fill_in "Password",          :with => "foobar"
          fill_in "Confirmation",      :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => 'Welcome')
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "signin/signout" do
    describe "failure" do
      it "should not sign in a user" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      before(:each) do
        @user = User.new( :name => "My Example", :email => "my@example.com",
                          :password => "agoodpassword",
                          :password_confirmation => "agoodpassword")
        @user.save
      end

      it "should sign in and sign out a user" do
        visit signin_path
        fill_in :email,     :with => @user.email
        fill_in :password,  :with => @user.password
        click_button
        controller.should be_signed_in
        click_link "Sign Out"
        controller.should_not be_signed_in
      end
    end
  end
end