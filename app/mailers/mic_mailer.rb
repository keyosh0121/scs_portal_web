class MicMailer < ApplicationMailer
  default from: "scs.portal.testing@gmail.com"
  def send_mic_to_admin(mic)
    @mic = mic
    #マイク練管理者にマイク練が申請された旨のメールを送信する
    mic_admin = User.find_by(authority: "mic")
    admin = User.find_by(authority: "admin")
    if mic_admin
      admin_email = mic_admin.email
    else
      admin_email = admin.email
    end

    mail(
      subject: "#{@mic.band}マイク練申請(#{@mic.date}-#{@mic.time})",
      to: "k.guitar121@gmail.com") do |format|
      format
    end
  end


  def send_mic_to_users(mic)

  end
end
