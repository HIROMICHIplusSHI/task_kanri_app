class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :admin_required, only: [:index, :destroy]

  def index
    @users = User.all.paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    @task_stats = calculate_task_stats(@user)
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

  def destroy
    @user = User.find(params[:id])

    if @user == current_user
      flash[:error] = "自分自身は削除できません"
      redirect_to users_path
      return
    end

    if @user.destroy
      flash[:success] = "#{@user.name}が削除されました"
    else
      flash[:error] = "削除に失敗しました"
    end
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_required
      unless admin_only
        flash[:error] = "アクセス権限がありません"
        redirect_to root_path
      end
    end

    def calculate_task_stats(user)
      tasks = user.tasks
      total = tasks.count
      return { total: 0, completed: 0, completion_rate: 0, status_breakdown: {} } if total == 0

      completed = tasks.where(status: "完了").count
      completion_rate = ((completed.to_f / total) * 100).round(1)

      status_breakdown = tasks.group(:status).count
      priority_breakdown = tasks.group(:priority).count

      {
        total: total,
        completed: completed,
        completion_rate: completion_rate,
        status_breakdown: status_breakdown,
        priority_breakdown: priority_breakdown
      }
    end
end
