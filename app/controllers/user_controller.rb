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
      session[:user_id] = @user.id
      redirect_to("/user/#{session[:user_id]}/show")
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
      password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect_to("/")
      flash[:notice] = "ログインしました"
    else
      @messages = Array.new()
      @errors = @user.errors
      flash[:notice] = "入力内容にエラーがあります"
      render("new")
    end
  end

  def show
    @user = User.find_by(id: session[:user_id])
    @notifs = Notification.order(created_at: "DESC").limit(5)
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました。"
    redirect_to("/")
  end
end
