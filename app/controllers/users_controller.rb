class UsersController < ApplicationController
  def index
    @pagy,@users = pagy(User.order(id: :desc),item:25)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
      render :new
    end
  end

  private
  # Strong Parameter
  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmatiion)
  end
end