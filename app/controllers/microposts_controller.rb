class MicropostsController < ApplicationController
  before_action :require_user_logged_in # この中の全アクションはログイン必須になる
  before_action :correct_user, only: [:destroy]
  
  # micropost 新規投稿機能
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "メッセージを投稿しました。"
      redirect_to root_url
    else
      @pagy,@microposts = pagy(current_user.feed_microposts.order(id: :desc))
      flash.now[:danger] = "メッセージの投稿に失敗しました。"
      render "toppage/index"
    end
  end

# micropost 削除機能
  def destroy
    @micropost.destroy
    flash[:success] = "メッセージを削除しました。"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
end
