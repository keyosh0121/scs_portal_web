class MicMailer < ApplicationMailer
  default from: "scs.portal.testing@gmail.com"
  def send_mic_to_user(mic)
    @mic = mic
    sender_name = @mic.user.name
    sender_email = @mic.user.email
    mail(
      subject: "#{@mic.band.name}マイク練申請(#{@mic.date} [#{@mic.period.name}])",
      to: sender_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end
  def send_mic_to_admin(mic)
    @mic = mic
    # addresses = User.where(authority:"mic").pluck('email')
    # if addresses.empty?
    #   user = User.find_by(authority:"admin")
    #   addresses.push(user.email)
    # end
    mail(
      subject: "[マイク練係]マイク練申請が届きました(#{mic.date.strftime("%m月%d日")})",
      to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_status_change(mic,text)
    @mic = mic
    @text = text
    user_email = @mic.user.email
    mail(
      subject: "マイク練が#{@mic.status_string}されました",
      to: user_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_room(mic)
    @mic = mic
    master_email = @mic.band.master.email
    mail(
      subject: "本日のマイク練部屋",
      to: master_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_room_wait(mic)
    @mic = mic
    master_email = @mic.band.master.email
    mail(
      subject: "マイク練キャンセル待ち",
      to: master_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_room_cancel(mic)
    @mic = mic
    master_email = @mic.band.master.email
    mail(
      subject: "マイク練部屋が取れませんでした",
      to: master_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_split_query(mics,mic)
    # 引数micsにはdate,period_idが一致する2つ以上のマイク練のActiceRecordを指定
    # 引数micにはそのうち問い合わせたいバンドのマイク練を指定
    @mics = mics
    @mic = mic
    user_email = @mic.band.master.email if @mic.band.master
    user_email = "test@gmail.com" unless @mic.band.master
    mail(
      subject: "【回答必須】マイク練の分割希望",
      to: user_email,
      reply_to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_mic_split_to_admin(mic)
    @mic = mic
    mail(
      subject: "#{@mic.date.strftime("%m月%d日" + "(#{%w(日 月 火 水 木 金 土)[@mic.date.wday]})")}の分割希望(#{mic.band.name})",
      to: 'scsmikesmith@gmail.com') do |format|
      format.html
      format.text
    end
  end
end
