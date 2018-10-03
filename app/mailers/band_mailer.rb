class BandMailer < ActionMailer::Base
  default from: "scs.portal.testing@gmail.com"
  layout 'mailer'

  def send_band_to_admin(band)
    @band = band
    mails = Array.new()
    admins = User.where(authority:"admin")
    admins.each do |admin|
      mails.push(admin.email)
    end
    # addresses = User.where(authority:"mic").pluck('email')
    # if addresses.empty?
    #   user = User.find_by(authority:"admin")
    #   addresses.push(user.email)
    # end
    mail(
      subject: "新しいバンド申請：#{@band.name}",
      to: 'mails') do |format|
      format.html
      format.text
    end
  end
end
