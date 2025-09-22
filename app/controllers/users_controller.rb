class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user.admin?
  end

  def update
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user.admin?

    if @user.update(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render :edit
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
