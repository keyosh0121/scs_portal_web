#encoding: utf-8

class UserController < ApplicationController

  def login
    @user = User.new(email:"")
    @email = ""
    @error = nil
    if @current_user
      redirect_to("/user/#{@current_user.id}/show")
    end
  end

  def login_user
    if User.find_by(email: params[:email])
      @user = User.find_by(email: params[:email])
      if params[:password] != @user.password
        @error = "パスワードが違います"
      end
    else
      @error = "Emailが違います"
    end
    if @user == nil || @user.password != params[:password]
      @email = params[:email]
      render("login")
    else
      @user.remember
      cookies.permanent.signed[:user_id] = @user.id
      cookies.permanent[:remember_token] = @user.remember_token
      if (session_id = session[:user_id])
        redirect_to("/user/#{session_id}/show")
      elsif (cookie_id = cookies.signed[:user_id])
        redirect_to("/user/#{cookie_id}/show")
      end
    end
  end

  def new
    @user = User.new()
    @errors = [""]
  end

  def register
    @user = User.new(name: params[:name],
      email: params[:email],
      tel: params[:tel],
      year: params[:year].to_i,
      univ: params[:univ],
      password: params[:password],
      approved: true)
    if @user.save
      session[:user_id] = @user.id
      redirect_to("/")
      flash[:notice] = "ログインしました"
      UserMailer.user_verification_mail(@user).deliver
      UserMailer.user_verification_mail_to_admin(@user).deliver
    else
      @messages = Array.new()
      @errors = @user.errors
      flash[:notice] = "入力内容にエラーがあります"
      render("new")
    end
  end

  def show
		self.user_authentificate
    if (session_user = User.find_by(id: session[:user_id]))
      @user = session_user
    elsif (cookie_user = User.find_by(id: cookies.signed[:user_id]))
      @user = cookie_user
    end
    @notifs = Notification.order(created_at: "DESC").limit(5)
  end

  def logout
    @current_user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"

    redirect_to("/")
  end

  def edit
    @user = @current_user
  end

  def edit_send
    @user = @current_user
    if @user.update(
      name: params[:name],
      email: params[:email],
      year: params[:year],
      tel: params[:tel],
      univ: params[:univ]
    )
      flash[:notice] = "内容を変更しました。"
      redirect_to("/user/#{@current_user.id}/show")
    else
      flash[:notice] = "変更できませんでした。内容を確認してください"
      render('user/edit')
    end

  end
end
