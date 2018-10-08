class BandMailer < ActionMailer::Base
  default from: "scs.portal.testing@gmail.com"
  layout 'mailer'

  def send_band_to_admin(band)
    @band = band
    mail(
      subject: "新しいバンド申請：#{@band.name}",
      to: 'arafubeatbox@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_band_information_change(band)
    @band = band
    mail(
      subject: "バンド情報の変更：#{@band.name}",
      to: 'arafubeatbox@gmail.com') do |format|
      format.html
      format.text
    end
  end

  def send_band_destroy(name)
    @name = name
    mail(
      subject: "バンドが消去されました：#{@name}",
      to: 'arafubeatbox@gmail.com') do |format|
      format.html
      format.text
    end
  end
end
