class MicMailer < ApplicationMailer
  default from: "scs.portal.testing@gmail.com"
  def send_mic_to_user(mic)
    @mic = mic
    sender_name = @mic.user.name
    sender_email = @mic.user.email
    mail(
      subject: "#{@mic.band.name}マイク練申請(#{@mic.date} [#{@mic.period.name}])",
      to: sender_email) do |format|
      format.html
    end
  end


  def send_mic_to_admin(mic)
    @mic = mic
    addresses = User.where(authority:"mic").pluck('email')
    if addresses.empty?
      user = User.find_by(authority:"admin")
      addresses.push(user.email)
    end
    mail(
      subject: "[マイク練係]マイク練申請が届きました(#{mic.date.strftime("%m月%d日")})",
      to: addresses) do |format|
      format.html
    end
  end

  def send_mic_status_change(mic,text)
    @mic = mic
    @text = text
    user_email = @mic.user.email
    mail(
      subject: "マイク練が#{@mic.status_string}されました",
      to: user_email) do |format|
      format.html
    end
  end

end
