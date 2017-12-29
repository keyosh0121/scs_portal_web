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

  def user_authority_edit
    user = User.find_by(id: params[:id])
    if params[:authority] == "nil"
      authority = nil
    else
      authority = params[:authority]
    end
    if user
      user.authority = authority
      if user.save
        flash[:notice] = "変更が完了しました"
        redirect_to('/database/users')
      else
        flash[:notice] = "変更できませんでした"
        redirect_to('/database/users')
      end
    else
      flash[:notice] = "変更できませんでした"
      redirect_to('/database/users')
    end
  end

  def user_approve
    user = User.find_by(id: params[:user_id])
    user.approval = true
    if user.save
      flash[:notice] = "ユーザーを承認しました"
			UserMailer.user_approved_mail(user).deliver
      redirect_to('/database/users')
    else
      flash[:notice] = "承認に失敗しました"
      redirect_to('/database/users')
    end
  end

  #マイク練管理
  def show_mic
    self.user_authentificate
    @mics = Mic.all.order('date DESC,time')
    @mic = Mic.new
  end

	def mic_approve
    @mics = Mic.all.order("date")
		@mic = Mic.find(params[:id])
		if @mic.update(:status => params[:status].to_i)
			flash[:notice] = "マイク練の詳細を変更しました"
			redirect_to('/database/mic-practice')
      MicMailer.send_mic_status_change(@mic,params[:text]).deliver
		else
			flash[:notice] = "変更に失敗しました"
			render('show_mic')
		end
	end

  #音響掲示板
  def mic_approvedlist
    @mics = Mic.where(status:'1').order('date DESC,time').page(params[:page]).per(10)
  end

  def show_infos
    self.user_authentificate
    @notif = Notification.new()
    @notifications = Notification.all
  end

  def add_infos
    @notif = Notification.new(
      content: params[:content],
      date: Date.today,
      time: Time.now
      )
    @notifications = Notification.all
    if @notif.save
      redirect_to("/database/notifications")
      flash[:notice] = "お知らせを投稿しました"
    else
      render("/admin/show_infos")
      flash[:notice] = "お知らせを投稿できませんでした。再度試して下さい"
    end
  end
  def delete_info
    @notification = Notification.find(params[:id])
    if @notification.destroy
      flash[:notice] = "お知らせを削除しました"
      redirect_to('/database/notifications')
    else
      flash[:notice] = "削除に失敗しました。"
      redirect_to('/database/notifications')
    end
  end

  def show_temporal_bands
    self.user_authentificate
    @temporal_bands = TemporalBand.all
  end

  def show_event
    self.user_authentificate
    @events = Event.all
    @event = Event.new()
  end

  def add_event
    string = params[:contents].split(",")
    puts string
    array = Array.new
    string.each do |str|
      content = EventContent.new(name: str, event: params[:name])
      content.save
    end
    @event = Event.new(
      name: params[:name],
      date: params[:date],
      start_time: params[:time],
      entry_required: params[:entry_required],
      able_to_comment: params[:able_to_comment],
      category: params[:category],
      event_type: params[:type].to_i
      )
    if @event.save
      flash[:notice] = "イベントを登録しました"
      redirect_to("/database/show-event")
    else
      flash[:notice] = "イベント登録に失敗しました。再度試してください。"
    end
  end

  def delete_event
    event = Event.find_by(id: params[:id])
    if event.destroy
      flash[:notice] = "イベントを削除しました"
      redirect_to("/database/show-event")
    else
      flash[:notice] = "イベントの削除に失敗しました。再度試してください"
      redirect_to("/database/show-event")
    end
  end
  def set_rooms_and_hours
    @hours = [1,2,3,8,4,5,6,7]
    @rooms = ["B101","B102","B103","B104","B105","B106","B123","B126"]
  end
  def mic_room_register
    self.user_authentificate
    self.set_rooms_and_hours
    @today_mics = Mic.where(date: Date.today).order('time')
  end

  def mic_room_register_send
    self.set_rooms_and_hours
		@today_mics = Mic.where(date: Date.today).order('time')
    array = Array.new()
    if params[:room1] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room1],
        date: Date.today,
        time: "1限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room2] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room2],
        date: Date.today,
        time: "2限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room3] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room3],
        date: Date.today,
        time: "3限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room4] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room4],
        date: Date.today,
        time: "4限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room5] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room5],
        date: Date.today,
        time: "5限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room6] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room6],
        date: Date.today,
        time: "6限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room7] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room7],
        date: Date.today,
        time: "7限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end
    if params[:room8] != "nil"
      @mic_room = MicRoom.new(
        room: params[:room8],
        date: Date.today,
        time: "昼限",
        reservation_type_num: 0
        )
      array.push(@mic_room)
    end

    successes = Array.new()
    array.each do |mic|
      if mic.save
        success = true
      else
        success = false
      end
      successes.push(success)
    end
    if successes.include?(false)
      flash[:notice] = "いくつか部屋が登録されませんでした。"
    else
      flash[:notice] = "部屋の登録が完了しました"
    end
    redirect_to('/database/mic/room-register')
  end

  def room_monthly
    self.set_rooms_and_hours
    @mic_rooms = MicRoom.where('date >= Date.today')
  end

  def room_monthly_send
    self.set_rooms_and_hours
    @microom = MicRoom.new(
      date: params[:date],
      time: params[:time],
      room: params[:room],
      reservation_type_num: 2
      )
    if @microom.save
      flash[:notice] = "予約内容を保存しました"
      redirect_to('/database/mic/room-register/monthly')
    else
      render('admin/room_monthly')
      flash[:notice] = "保存できませんでした。再度試して下さい"
    end
  end

  def room_weekly
    self.set_rooms_and_hours
    @mic_rooms = MicRoom.where('date >= Date.today')
  end

  def room_weekly_send
    self.set_rooms_and_hours
    @microom = MicRoom.new(
      date: params[:date],
      time: params[:time],
      room: params[:room],
      reservation_type_num: 1
      )
    if @microom.save
      flash[:notice] = "予約内容を保存しました"
      redirect_to('/database/mic/room-register/weekly')
    else
      flash[:notice] = "保存できませんでした。再度試して下さい"
      render('admin/room_weekly')
    end
  end

  def mic_list
    @mic = Mic.all
    @room = MicRoom.all
  end
end

