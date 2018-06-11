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
      unless @user.authenticate(params[:password])
        @error = "パスワードが違います"
      end
    else
      @error = "Emailが違います"
    end
    if @user == nil || !@user.authenticate(params[:password])
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
    if params[:year] == ""
      year = nil
    else
      year = params[:year].to_i
    end
    @user = User.new(name: params[:name],
      email: params[:email],
      tel: params[:tel],
      year: year,
      univ: params[:univ],
      password: params[:password],
      section: params[:section])
    @user.name_space_validation
    if @user.save && params[:password] == params[:password_confirmation] && @user.name_space_validation
      session[:user_id] = @user.id
      redirect_to("/")
      flash[:notice] = "ログインしました"
      UserMailer.user_verification_mail(@user).deliver
      UserMailer.user_verification_mail_to_admin(@user).deliver
    else
      if params[:password] != params[:password_confirmation]
        @user.password_confirmation_failure
      end
      @user.name_space_validation
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
      univ: params[:univ],
      section: params[:section]
    )
      flash[:notice] = "内容を変更しました。"
      redirect_to("/user/#{@current_user.id}/show")
    else
      flash[:notice] = "変更できませんでした。内容を確認してください"
      render('user/edit')
    end
  end

  def password_reset_sender
  end

  def password_reset_sent
    @user = User.find_by(email:params[:email])
    UserMailer.password_reset_mail(@user).deliver
    flash[:notice] = "メールを送信しました。確認してください。"
    render :file => "/home/top"
  end

  def password_reset
  end

  def password_reset_done
    if params[:password] == params[:passwordagain]
      @user = User.find_by(id: params[:id])
      @user.update_attribute(password: params[:password])
      flash[:notice] = "変更されました。"
      redirect_to("login")
    else
      flash[:notice] = "再入力されたパスワードが一致しません。"
      redirect_to("/user/#{params[:id]}/password")
    end
  end

end
