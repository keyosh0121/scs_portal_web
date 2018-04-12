class PasswordResetController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to '/'
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      flash[:notice] = "パスワードを変更しました。"
      redirect_to '/'
    else
      render 'edit'
    end
  end

  def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
  def valid_user
    unless (@user && @user.approval)
      redirect_to '/'
    end
  end
end
