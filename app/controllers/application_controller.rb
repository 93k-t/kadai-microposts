class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  
  private
# 全てのControllerがApplicationControllerを継承しているためこの中で定義したメソッドは全てのControllerで使用可能
  def require_user_logged_in
# unless ifの反対、ifはtrueの時に処理を実行するのに対し、unlessはfalseの時に処理を実行
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_microposts = user.microposts.count
  end
end
