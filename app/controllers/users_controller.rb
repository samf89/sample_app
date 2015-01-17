class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params_for_user)
    if @user.save
      #handle the save event
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def params_for_user
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
