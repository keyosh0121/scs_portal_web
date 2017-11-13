class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def user_authentificate
    if @current_user == nil
      flash[:notice] = "ログインが必要な機能です。"
      redirect_to('/login')
    elsif @current_user.approval == false
      flash[:notice] = "管理者の承認が完了していません。"
      redirect_to('/')
    end
  end

end
