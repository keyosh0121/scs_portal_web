class MicMailer < ApplicationMailer
  default from: "scs.portal.testing@gmail.com"
  def send_mic_to_user(mic)
    @mic = mic
    sender_name = @mic.sender
    sender = User.find_by(name: sender_name)
    sender_email = sender.email
    mail(
      subject: "#{@mic.band}マイク練申請(#{@mic.date} [#{@mic.time}])",
      to: sender_email) do |format|
      format.html
    end
  end


  def send_mic_to_admin(mic)
    @mic = mic
    admins = User.where(authority:"mic")
    addresses = Array.new()
    admins.each do |admin|
      addresses.push(admin.email)
    end
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
    user_email = User.find_by(name: @mic.sender).email
    mail(
      subject: "マイク練が#{@mic.status}されました",
      to: user_email) do |format|
      format.html
    end
  end

end
