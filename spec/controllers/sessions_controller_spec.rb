require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    # it "should have the right title" do
    #   get :new
    #   response.should have_selector("title", :content => "Sign In")
    # end

    describe "invalid signin" do
      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      # it "should have the right title" do
      #   post :create, :session => @attr
      #   response.should render_selector('title', :content => "Sign In")
      # end

      it "should have flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    describe "valid signin" do

      before(:each) do
        @user = User.new( :name => "David Silver",
                          :email => "email@example.com",
                          :password => "valid_password",
                          :password_confirmation => "valid_password")
        @user.save
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign in the user" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end

  describe "DELETE 'destroy'" do
      before(:each) do
        @user = User.new( :name => "David Silver",
                          :email => "email@example.com",
                          :password => "valid_password",
                          :password_confirmation => "valid_password")
        @user.save
        @attr = { :email => @user.email, :password => @user.password }
      end

    it "should sign out a user" do
      test_sign_in(@user)
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
