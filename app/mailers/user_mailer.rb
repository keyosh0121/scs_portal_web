class UserMailer < ApplicationMailer
  def user_verification_mail_to_admin(user)
    @user = user
    mails = Array.new()
    admins = User.where(authority:"admin")
    admins.each do |admin|
      mails.push(admin.email)
    end
    mail(
      subject: "【SCS Portal】新規ユーザーの登録があります)",
      to: mails) do |format|
      format.html
      format.text
    end
  end

  def user_verification_mail(user)
    @user = user
    mail(
      subject: "【SCS Portal】仮登録完了のお知らせ",
      to: @user.email) do |format|
      format.html
      format.text
    end
  end

	def user_approved_mail(user)
		@user = user
		mail(
			subject: "ユーザーが承認されました",
			to: @user.email) do |format|
			format.html
      format.text
		end
	end
  def contact_form_mail(contact)
    admin_mails = User.where(authority: "admin").pluck('email')
    @contact = contact
    mail(
      subject:"お問い合わせが届きました",
      to: admin_mails
      ) do |format|
      format.html
      format.text
    end
  end

  def password_reset(user)
    @user = user
    mail(
      subject:"パスワード変更",
      to: @user.email
      ) do |format|
      format.html
      format.text
    end
  end


end
