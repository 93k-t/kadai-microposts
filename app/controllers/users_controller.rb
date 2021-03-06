class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  def index
    @pagy,@users = pagy(User.order(id: :desc),item:25)
  end

  def show
    @user = User.find(params[:id])
    @pagy, @microposts = pagy(@user.microposts.order(id: :desc))
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザを登録しました。"
# redirect_to users#showアクションへ強制的に移動させ createアクション実行後さらにshowアクションが実行、show.html.erb を呼ぶ
      redirect_to @user
    else
      flash.now[:danger] = "ユーザの登録に失敗しました。"
# render :new users/new.html.erb を表示するだけで(users#newアクションは実行しない)
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @pagy,@followings = pagy(@user.followings)
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @pagy,@followers = pagy(@user.followers)
    counts(@user)
  end
  
  # お気に入り投稿一覧表示
  def likes
    @user = User.find(params[:id])
    @pagy, @likes = pagy(@user.favoritings)
    counts(@user)
  end

  private
  # Strong Parameter
  def user_params
    params.require(:user).permit(:name, :email, :password,:password_confirmatiion)
  end
end