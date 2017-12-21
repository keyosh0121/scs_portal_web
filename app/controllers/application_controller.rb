class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_current_user

  def set_current_user
    if (user_id = session[:user_id])
      @current_user = User.find(user_id)
    elsif (user_id = cookies.signed[:user_id])
      if user && user.authenticated?(cookies[:remember_token])
        @current_user = user
      end
    end
  end

  def user_authentificate
		#ログインしていない場合、もしくは管理者の承認が得られていない場合
    if @current_user == nil
      flash[:notice] = "ログインが必要な機能です。"
      redirect_to('/login')
    elsif @current_user.approval == false
      flash[:notice] = "管理者の承認が完了していません。"
      redirect_to('/')
    end
  end
	def permit_access_only_for(authority)
		#引数に指定された権限のユーザーのみアクセス可能にするメソッド
		if @current_user.authority != authority
			flash[:notice] = アクセス権限がありません
			redirect_to('/user/#{@current_user.id}/show')
		end
	end
end
