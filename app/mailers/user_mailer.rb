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
    end
  end
  def user_verification_mail(user)
    @user = user
    mail(
      subject: "【SCS Portal】仮登録完了のお知らせ",
      to: @user.email) do |format|
      format.html
    end
  end

end
