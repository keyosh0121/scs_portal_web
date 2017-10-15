class AdminController < ApplicationController
  def top
    if @current_user
      if !@current_user.authority
        redirect_to("/user/#{@current_user.id}/show")
        flash[:notice] = "権限がありません"
      end
    else
      redirect_to("/login")
      flash[:notice] = "ログインが必要な機能です。"
    end
  end

  def show_bands
    self.user_authentificate
    @bands = Band.where(registration: false)
  end

  def show_registered_bands
    @bands = Band.where(registration: true)
  end

  def register_band
    @band = Band.find_by(id: params[:id])
    @band.registration = true
    if @band.save
      flash[:notice] = "#{@band.name}を正規バンドとして登録しました。"
      redirect_to("/database/bands")
      notification = Notification.new(date: Date.today, time: Time.now, content: "正規バンドに「#{@band.name}」が追加されました。")
      notification.save
    else
      flash[:notice] = "保存中にエラーが起きました。もう一度試して下さい。"
      redirect_to("/database/bands")
    end
  end

  def show_users
    self.user_authentificate
    @users = User.all
  end

  def show_mic
    self.user_authentificate
    @mics = Mic.all.order("date")
  end

  def show_infos
    self.user_authentificate
    @notif = Notification.new()
  end

  def add_infos
    @notif = Notification.new(
      content: params[:content],
      date: Date.today,
      time: Time.now
      )
    if @notif.save
      redirect_to("/database/notifications")
      flash[:notice] = "お知らせを投稿しました"
    else
      render("/admin/show_infos")
      flash[:notice] = "お知らせを投稿できませんでした。再度試して下さい"
    end
  end

  def show_temporal_bands
    self.user_authentificate
    @temporal_bands = TemporalBand.all
  end

  def add_event
    @event = Event.new(
      name: params[:name],
      date: params[:date]
      )
    if @event.save
      flash[:notice] = "イベントを登録しました"
      redirect_to("/database/temporal-bands")
    else
      flash[:notice] = "イベント登録に失敗しました。再度試してください。"
    end
  end
end

