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

  def send_mic_split_query(mics,mic)
    # 引数micsにはdate,period_idが一致する2つ以上のマイク練のActiceRecordを指定
    # 引数micにはそのうち問い合わせたいバンドのマイク練を指定
    @mics = mics
    @mic = mic
    user_email = @mic.band.master.email
    mail(
      subject: "【回答必須】マイク練の分割希望",
      to: user_email) do |format|
      format.html
    end
  end
end
