class AdminController < ApplicationController
  def top
    if @current_user
      if @current_user.authority != "admin"
        redirect_to("/user/#{@current_user.id}/show")
        flash[:notice] = "権限がありません"
      end
    else
      redirect_to("/login")
      flash[:notice] = "ログインが必要な機能です。"
    end
  end

  def band_detail
    @band = Band.find(params[:id])
  end

  def show_registered_bands
    @bands = Band.where(registration: true)
    @years = [Date.today.year, Date.today.year - 1, Date.today.year - 2, Date.today.year - 3]
    @bands_by_year = [@bands.where(year: @years[0]), @bands.where(year: @years[1]), @bands.where(year: @years[2]), @bands.where(year: @years[3])]
  end

  def register_band
    @band = Band.find_by(id: params[:id])
    @band.registration = true
    if @band.save
      flash[:notice] = "#{@band.name}を正規バンドとして登録しました。"
      redirect_to("/database/bands/detail/#{@band.id}")
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
  def user_reject
    user = User.find_by(id: params[:user_id])
    user.delete
    if user.save
      flash[:notice] = "ユーザーを拒否しました"
      redirect_to('/database/users')
    else
      flash[:notice] = "承認に失敗しました"
      redirect_to('/database/users')
    end
  end

  #マイク練管理
  def show_mic
    self.user_authentificate
  end

  def show_unregistered_mic
    self.user_authentificate
  end

  def band_detail_mic
    @band=Band.find(params[:id])
  end

	def mic_approve
    @mics = Mic.all.order("date")
		@mic = Mic.find(params[:id])
		if @mic.update(:status => 1)
			flash[:notice] = "マイク練を承認しました"
			redirect_to('/database/mic-practice/unapproved')
      MicMailer.send_mic_status_change(@mic,params[:text]).deliver
		else
			flash[:notice] = "変更に失敗しました"
			render('show_mic')
		end
	end

  def mic_delete
    @mic = Mic.find(params[:id])
    if @mic.delete
      flash[:notice] = "マイク練を削除しました"
      redirect_to('/database/mic-practice')
    else
      flash[:notice] = "削除に失敗しました。再度試してください。"
      render('show_mic')
    end
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
    @events = Event.where("(event_type = ?) OR (event_type = ?)", 2, 3)
    @temporal_bands = TemporalBand.all
  end

  def show_event
    self.user_authentificate
    @events = Event.all
    @event = Event.new()
  end

  def add_event
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

    string = params[:contents].split(",")
    puts string
    array = Array.new
    string.each do |str|
      content = EventContent.new(name: str, event_id: @event.id)
      content.save
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
  def micinfo_register
    @date = Date.strptime(params[:date])
    @mics = Mic.where(date: @date)
  end

	def micinfo_register_send_confirm
		@date = Date.strptime(params[:date])
    @mics = Mic.where(date: @date)
    @mail_mics = []
    @texts = []
    @mics.each_with_index do |mic, index|
      mic_hash = {}
      mic_hash[:mic] = mic
      key_1=mic.period_id.to_s.to_sym
      room_text = mic.mic_room_text(params[key_1])
      mic_hash[:room_id] = params[key_1]
      key_2 = mic.id.to_s.to_sym
      order = params[:order][key_2] if params[:order]
      if order
        start_time = (params[:start_time]["#{mic.id}(4i)"] + ":" + params[:start_time]["#{mic.id}(5i)"]).to_time
        end_time = (params[:end_time]["#{mic.id}(4i)"] + ":" + params[:end_time]["#{mic.id}(5i)"]).to_time
        order_text = mic.mic_split_order_text(order)
        time_text = mic.mic_split_time_text(start_time, end_time)
        split_text = order_text + time_text
        mic_hash[:order] = order
        mic_hash[:start_time] = start_time
        mic_hash[:end_time] = end_time
      else
        split_text = ""
      end
      if (room_text != "") || (split_text != "" && split_text != "本日の分割は#{mic.order}番目です。")
        text = room_text + split_text
        mic_hash[:room_text] = room_text
        if Room.find(mic_hash[:room_id]).name != "空き部屋なし"
          mic_hash[:split_text] = split_text
        else
          mic_hash[:split_text] = ""
        end
        @mail_mics << mic_hash
      end
    end

    if @mail_mics == []
      flash[:notice] = "変更情報はありませんでした"
      redirect_to('/database/mic-practice')
    end
	end

  def micinfo_register_send
    params[:num].to_i.times do |index|
      param = params[:mic][index.to_s.to_sym]
      mic = Mic.find(param[:mic_id])
      room_text = param[:room_text]
      split_text = param[:split_text]
      room_id = param[:room_id]
      start_time = param[:start_time]
      end_time = param[:end_time]
      order = param[:order]
      MicMailer.send_mic_info(mic,room_text,split_text).deliver
      if room_id != ""
        mic.update(room_id: room_id)
      end
      if start_time != ""
        mic.update(start_time: start_time)
      end
      if end_time != ""
        mic.update(end_time: end_time)
      end
      if order != ""
        mic.update(order: order)
      end
    end
    flash[:notice] = "情報を登録しました"
    redirect_to('/database/mic-practice')
  end


  def mic_remark
    @mic = Mic.find(params[:id])
  end

  def mic_split_time
  end

  def practice_room
    @dates = RoomUsage.all.pluck('date').uniq.reverse
  end

  def mic_order_register
    @mic = Mic.find(params[:id])
  end
  def mic_order_register_send
    @mic = Mic.find(params[:id])
    @mic.update!(order: params[:order])
    MicMailer.send_mic_split_to_admin(@mic).deliver
    if @mic.overlapped_mics.select{|m| m.order == nil}.any?
      date = @mic.date; period_id = @mic.period_id
      mics = Mic.where(date: date).where(period_id: period_id)
      mic = @mic.overlapped_mics.select{|m| m.order == nil}.first
      MicMailer.send_mic_split_query(mics,mic).deliver
    end
    flash[:notice] = "#{@mic.order}番目を希望しました"
    redirect_to('/')
  end
end

