class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]

  def new
    if(current_user)
      redirect_to(root_path)
    else
      @user = User.new
      @title = "Sign Up"
    end
  end

  def index
    @title = "All Users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def create
    if(current_user)
      redirect_to(root_path)
    else
      @user = User.new(params[:user])
      if(@user.save)
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @user.password = nil
        @user.password_confirmation = nil
        @title = 'Sign Up'
        render 'new'
      end
    end
  end

  def edit
    @title = "Edit User"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to(root_path)
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'  
  end

  private
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    if current_user.nil?
      redirect_to(signin_path)
    elsif current_user.admin? == false
        redirect_to(root_path)
    end
  end
end
