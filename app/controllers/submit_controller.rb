class SubmitController < ApplicationController
  protect_from_forgery :except => [:get_content]
  def mic
    self.user_authentificate
    @mic = Mic.new()
    if @current_user
      @mics = @current_user.mics
      @user_bands = @current_user.bands
    end
  end

  def mic_list
    self.user_authentificate
    @mic = Mic.new()
    if @current_user
      @mics = @current_user.mics
      @user_bands = @current_user.bands
    end
  end

  def mic_submit
    @mics = @current_user.mics
    @user_bands = @current_user.bands
    if params[:paattendance] == "参加"
      attendance = "参加"
    else
      attendance = "不参加"
    end
    if Band.find_by(name: params[:band])
      pa = Band.find_by(name: params[:band]).pa
    else
      pa = "指定なし"
    end
    @mic = Mic.new(
      band: params[:band],
      sender: @current_user.name,
      date: params[:date],
      time: params[:time],
      paattendance: attendance,
      pa: pa,
      status: 0
      )
    params[:paattendance]
    if @mic.save
      redirect_to("/submit/mic-list")
      flash[:notice] = "マイク練申請が完了しました。"
      MicMailer.send_mic_to_user(@mic).deliver
      MicMailer.send_mic_to_admin(@mic).deliver
    else
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      render("/submit/mic")
    end
  end

  def mic_destroy
    mic = Mic.find_by(id: params[:id])
    if mic.delete
      flash[:notice] = "マイク練申請が取り消されました"
      redirect_to('/submit/mic-list')
    else
      flash[:notice] = "処理に失敗しました。再度取消処理を行ってください"
      redirect_to('/submit/mic-list')
    end
  end

  def comment
    self.user_authentificate
    @conferences = Event.where(category:"conference")
    @contents = []
		@comment = Comment.new
  end
  def get_content
    if params[:event_name]
      @contents = EventContent.where(event: params[:event_name])
      render json: @contents
      @contents.each do |con|
        puts con.name
      end
    end
  end

  def comment_list
    @sent_comments = Comment.where(sender:@current_user.name)
  end

  def comment_conference
    self.user_authentificate
		@comment = Comment.new
    @conferences = Event.where(category:"conference")
    @contents = []
  end

  def comment_destroy
    @comment = Comment.find_by(id: params[:id])
    ReplyToComment.where(comment_id: @comment.id).delete_all
    if @comment.delete
      flash[:notice] = "コメントを削除しました"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "削除に失敗しました。再度試して下さい"
      redirect_to('/submit/comment/list')
    end
  end

  def comment_conference_send
    @comment = Comment.new(
      sender: @current_user.name,
      atevent: params[:atevent],
      atcontent: params[:atcontent],
      comment: params[:comment]
    )
    if @comment.save
      flash[:notice] = "コメントが送信されました。"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "送信に失敗しました。再度試して下さい。"
      render('/submit/comment_conference')
    end
  end

  def comment_performance
    self.user_authentificate
    @comment = Comment.new()
    @auditions = Event.where(category:"audition",able_to_comment: true)
    @contents = []
  end

  def comment_detail_show
    @comment = Comment.find(params[:id])
  end

  def comment_reply_send
    @comment = Comment.find(params[:id])
    @reply = ReplyToComment.new(
      comment_id: params[:id],
      sender_id: @current_user.id,
      text: params[:text]
      )
    if @reply.save
      flash[:notice] = "コメントに返信しました"
      redirect_to("/submit/comment/list/detail/#{params[:id]}")
    else
      flash[:notice] = "送信が失敗しました。再度試してください。"
      redirect_to("/submit/comment/list/detail/#{params[:id]}")
    end
  end

  def comment_reply_delete
    if ReplyToComment.find(params[:id]).destroy
      flash[:notice] = "コメントへの返信を削除しました。"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "削除に失敗しました。もう一度試してください。"
      render('/submit/comment_list')
    end
  end

  def comment_performance_send
    @comment = Comment.new(
      sender: @current_user.name,
      atevent: params[:atevent],
      atcontent: params[:atcontent],
      comment: params[:comment]
    )
    if @comment.save
      flash[:notice] = "コメントが送信されました。"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "送信に失敗しました。再度試して下さい。"
      render('/submit/comment_list')
    end
  end

  def all_comment_menu
		self.user_authentificate
    @conferences = Event.where(category:"conference")
  end
  def all_comment_conf
    @conference = Event.find(params[:conf_id])
    @comments = Comment.where(atevent: @conference.name)

  end

  def regular_band
    self.user_authentificate
    @band = Band.new()
  end

  def regular_band_submit
    members = Array.new()
    if params[:member1] != ""
      members.push(params[:member1])
    end
    if params[:member2] != ""
      members.push(params[:member2])
    end
    if params[:member3] != ""
      members.push(params[:member3])
    end
    if params[:member4] != ""
      members.push(params[:member4])
    end
    if params[:member5] != ""
      members.push(params[:member5])
    end
    if params[:member6] != ""
      members.push(params[:member6])
    end
    if params[:member7] != ""
      members.push(params[:member7])
    end
    if params[:member8] != ""
      members.push(params[:member8])
    end
    @band = Band.new(
      name: params[:name],
      pa: params[:pa],
      members: members,
      master: params[:master],
      description: params[:description],
      year: Date.today.year,
      image: "default-band.jpg"
      )
    if params[:image]
      image = params[:image]
      @band.image = "#{@band.name}.jpg"
      File.binwrite("public/band-images/#{@band.image}", image.read)
    end

    if @band.save
      redirect_to("/user/#{session[:user_id]}/show")
      flash[:notice] = "正規バンドの申請を受け付けました"
    else
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      render("submit/regular_band")
    end
  end

  def temporal_band
    self.user_authentificate
    @temporal_band = TemporalBand.new()
    @events = Event.where(entry_required: true)
  end

  def temporal_band_submit
    @events = Event.all
    members = Array.new()
    if params[:member1] != ""
      members.push(params[:member1])
    end
    if params[:member2] != ""
      members.push(params[:member2])
    end
    if params[:member3] != ""
      members.push(params[:member3])
    end
    if params[:member4] != ""
      members.push(params[:member4])
    end
    if params[:member5] != ""
      members.push(params[:member5])
    end
    if params[:member6] != ""
      members.push(params[:member6])
    end
    if params[:member7] != ""
      members.push(params[:member7])
    end
    if params[:member8] != ""
      members.push(params[:member8])
    end
    @temporal_band = TemporalBand.new(
      name: params[:name],
      members: members,
      event: params[:event]
      )
    if @temporal_band.save
      flash[:notice] = "企画バンドの申請が完了しました。"
      redirect_to("/user/#{@current_user.id}/show")
    else
      puts @temporal_band.errors.full_messages
      flash[:notice] = "登録に失敗しました。入力内容を確認してください"
      render("submit/temporal_band")
    end
  end

  def room
    @usages = RoomUsage.all
    @usage = RoomUsage.new()
    self.user_authentificate
  end

  def room_send
    @usages = RoomUsage.all
    puts
    @usage = RoomUsage.new(
      room: params[:room],
      band: params[:band],
      sender: @current_user.name,
      date: params[:date],
      period: params[:time]
      )
    if @usage.save
      flash[:notice] = "申請しました。"
      render('submit/room')
    else
      flash[:notice] = "申請できませんでした。再度試してください。"
      @errors = @usage.errors.full_messages
      render('submit/room')
    end
  end

  def show_infos
    self.user_authentificate
  end

  def add_infos
    self.user_authentificate
  end

  def entry_top
		self.user_authentificate
    @events = Event.where(entry_required: true)
    @entry = Entry.new
  end
  def entry_event
		self.user_authentificate
    @event = Event.find(params[:id])
    @entry = Entry.new
  end
  def entry_event_submit
    event = Event.find(params[:id])
    @event = Event.find(params[:id])
    if params[:regular_band]
      r_band_id = params[:regular_band].to_i
    else
      r_band_id = nil
    end
    if params[:temporal_band]
      t_band_id = params[:temporal_band].to_i
    else
      t_band_id = nil
    end
    @entry = Entry.new(
      user_id: @current_user.id,
      event_id: event.id,
      entry_type: event.event_type,
      regular_band_id: r_band_id,
      temporal_band_id: t_band_id,
      message: params[:message]
      )
    if @entry.save
      flash[:notice] = "エントリーしました"
      redirect_to('/submit/entry')
    else
      flash[:notice] = "エントリーできませんでした。再度試してください。"
      render('submit/entry_event')
    end
  end
  def entry_list
		self.user_authentificate
    @entries = @current_user.entries
  end
  def entry_admin
    self.user_authentificate
    @events = Event.where(entry_required: true)
  end
  def event_entry_to_csv
    @event = Event.find(params[:event_id])
		@entries = Entry.where(event_id: @event.id)
	end
  def entry_admin_list
  end

end
