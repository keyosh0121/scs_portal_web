class SubmitController < ApplicationController
  protect_from_forgery :except => [:get_content]
  def mic
    self.user_authentificate
    @periods = Period.all
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
      @mics = @current_user.bands.map{|band| band.mics.select {|m| m.date >= Date.today}}
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
    @mic = Mic.new(
      band_id: params[:band_id],
      user_id: @current_user.id,
      date: params[:date],
      period_id: params[:period_id],
      paattendance: attendance,
      status: 0,
      remark: params[:remark]
      )
    params[:paattendance]
    if @mic.save
      redirect_to("/submit/mic-list")
      flash[:notice] = "マイク練申請が完了しました。"
      MicMailer.send_mic_to_user(@mic).deliver
      MicMailer.send_mic_to_admin(@mic).deliver
    else
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      @periods = Period.all
      render("submit/mic")
    end
  end

  def mic_destroy
    mic = Mic.find_by(id: params[:id])
    if mic.delete
      flash[:notice] = "マイク練申請が取り消されました"
      MicMailer.send_mic_destroy_to_admin(mic).deliver
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
      @conference = Event.find_by(name: params[:event_name])
      @contents = @conference.event_contents
      render json: @contents
      @contents.each do |con|
        puts con.name
      end
    end
  end

  def comment_list
    @sent_comments = @current_user.comments
  end

  def comment_conference
    self.user_authentificate
		@comment = Comment.new
    @conferences = Event.where(category:"conference")
    @contents = []
  end

  def comment_destroy
    @comment = Comment.find_by(id: params[:id])
    Comment.where(reply_to: @comment.id).delete_all
    if @comment.delete
      flash[:notice] = "コメントを削除しました"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "削除に失敗しました。再度試して下さい"
      redirect_to('/submit/comment/list')
    end
  end

  def comment_conference_send
    content=EventContent.find_by(name: params[:atcontent])
	  @conferences = Event.where(category:"conference")
    @comment = Comment.new(
      user_id: @current_user.id,
      event_id: content.event_id,
      event_content_id: content.id,
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
    @reply = Comment.new(
      reply_to: params[:id],
      user_id: @current_user.id,
      event_id: @comment.event_id,
      event_content_id: @comment.event_content_id,
      comment: params[:text]
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
    if Comment.find(params[:id]).destroy
      flash[:notice] = "コメントへの返信を削除しました。"
      redirect_to('/submit/comment/list')
    else
      flash[:notice] = "削除に失敗しました。もう一度試してください。"
      render('/submit/comment_list')
    end
  end

  def comment_performance_send
    @comment = Comment.new(
      user_id: @current_user.id,
      event_id: Event.find_by(name: params[:atevent]).id,
      event_content_id: EventContent.find_by(name:params[:atcontent], event:params[:atevent]).id,
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
    @comments = @conference.comments
  end

  def regular_band
    self.user_authentificate
    @band = Band.new()
    @names = User.all.map(&:name)
    @mem = []
    gon.names = @names
  end

  def regular_band_submit
    members = Array.new()
    master_id = User.find_by(name:params[:master]).id if User.find_by(name:params[:master])
    pa_id = User.find_by(name:params[:pa]).id if User.find_by(name:params[:pa])
    @band = Band.new(
      name: params[:name],
      pa_id: pa_id,
      master_id: master_id,
      description: params[:description],
      year: params[:year].to_i,
      image: "default-band.jpg",
      website: params[:website],
      feature: params[:feature],
      band_type: 0
    )
    member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
    @mem = member_names
    error_counter = 0
    8.times do |i|
      key = ("member"+(i+1).to_s).to_sym
      if params[key] != ""
        if User.find_by(name:member_names[i])
        else
          error_counter += 1
        end
      else
      end
    end
    @pa = params[:pa]
    @master = params[:master]
    if params[:image]
      image = params[:image]
      @band.image = "#{@band.name}.jpg"
      File.binwrite("public/band-images/#{@band.image}", image.read)
    end
    if @band.save && error_counter == 0
      #member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
      8.times do |i|
        #TODO:例外処理
        BandMember.create(user_id: User.find_by(name: member_names[i]).id,band_id: @band.id,mic_number: i+1) if User.find_by(name: member_names[i])
      end
      redirect_to("/user/#{@current_user.id}/show")
      flash[:notice] = "正規バンドの申請を受け付けました"
    elsif error_counter > 0
        @names = User.all.map(&:name)
        flash[:notice] = "登録に失敗しました。#{error_counter}人の名前が登録されていません。"
        render("submit/regular_band")
    else
      puts @band.errors.full_messages
      @names = User.all.map(&:name)
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      #redirect_to :action => "regular_band"
      render("submit/regular_band")
    end
  end

  def temporal_band
    self.user_authentificate
    @temporal_band = Band.new()
    @names = User.all.map(&:name)
    @events = Event.where(entry_required: true)
    @mem = []
  end

  def temporal_band_submit
    @events = Event.all
    master_id = User.find_by(name:params[:master]).id if User.find_by(name:params[:master])
    @master = params[:master]
    member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
    @mem = member_names
    error_counter = 0
    8.times do |i|
      key = ("member"+(i+1).to_s).to_sym
      if params[key] != ""
        if User.find_by(name:member_names[i])
        else
          error_counter += 1
        end
      else
      end
    end

    if params[:event]
      @temporal_band = Band.new(
        name: params[:name],
        master_id: master_id,
        band_type: 1,
        event_id: Event.find_by(name: params[:event]).id
        )
      if @temporal_band.save && error_counter == 0
        flash[:notice] = "企画バンドの申請が完了しました。"
        8.times do |i|
         #TODO:例外処理
            BandMember.create(band_id: @temporal_band.id, user_id: User.find_by(name: member_names[i]).id,mic_number: i+1) if User.find_by(name:member_names[i])
        end
        redirect_to("/user/#{@current_user.id}/show")
      elsif error_counter > 0
        @names = User.all.map(&:name)
        flash[:notice] = "登録に失敗しました。#{error_counter}人の名前が登録されていません。"
        render("submit/temporal_band")
      else
        puts @temporal_band.errors.full_messages
        @names = User.all.map(&:name)
        flash[:notice] = "登録に失敗しました。入力内容を確認してください"
        render("submit/temporal_band")
      end
    else flash[:notice] = "申請に失敗しました。イベントを選択してください。"
         redirect_to :action => "temporal_band"
    end
  end
=begin   申請ミス時入力保持用。実装途中
  def temporal_band_submit
    @events = Event.all
    @temporal_band = Band.new(
        name: params[:name],
        band_type: 1,
        event_id: Event.find_by(name: params[:event]).id
        )
    member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
    @mem = member_names

      if !params[:event]
        puts @temporal_band.errors.full_messages
        flash[:notice] = "申請に失敗しました。イベントを選択してください。"
        @events = Event.where(entry_required: true)
        #render("submit/temporal_band")
        redirect_to :action => "temporal_band"
      end
      if @temporal_band.save
        flash[:notice] = "企画バンドの申請が完了しました。"
        8.times do |i|
         #TODO:例外処理
         BandMember.new(band_id: @temporal_band.id, name: member_names[i],part: i).save if member_names[i]
        end
        redirect_to("/user/#{@current_user.id}/show")
      else
        flash[:notice] = "登録に失敗しました。入力内容を確認してください"
        #render("submit/temporal_band")
        redirect_to :action => "temporal_band"
      end
  end
=end
  def room
    @usages = RoomUsage.where(date: Date.today)
    @usage = RoomUsage.new()
    @periods = Period.all
    @bands = @current_user.bands.where(band_type: 0)
    self.user_authentificate
  end

  def room_send
    @periods = Period.all
    @usages = RoomUsage.all
    dummy_band_id= nil
    dummy_band_id=Band.find_by(name:params[:band]).id  if Band.find_by(name:params[:band])
    period_ids = []
    Period.all.each do |p|
      period_ids.push(p.id) if params["period_#{p.id}".to_sym]
      puts params["period_#{p.id}".to_sym]
    end
    usages = []
    period_ids.each do |p|
      usages.push(RoomUsage.new(
          room_id: params[:room].to_i,
          band_id: dummy_band_id,
          user_id: @current_user.id,
          date: params[:date],
          applicant: params[:band],
          period_id: p.to_i
          ))
    end
    usages.each{|u| u.save!}
    redirect_to('/submit/room')
  end

  def room_destroy
    usage = RoomUsage.find_by(id: params[:id])
    if usage.delete
      flash[:notice] = "利用申請が取り消されました"
      redirect_to('/submit/room')
    else
      flash[:notice] = "処理に失敗しました。再度取消処理を行ってください"
      redirect_to('/submit/room')
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
    musics = []
    times = []
    if params[:music1]
      musics.push(params[:music1])
      if params[:time1]
        times.push(params[:time1])
      end
    end
    if params[:music2]
      musics.push(params[:music2])
      if params[:time2]
        times.push(params[:time2])
      end
    end
    if params[:music3]
      musics.push(params[:music3])
      if params[:time3]
        times.push(params[:time3])
      end
    end
    if params[:music4]
      musics.push(params[:music4])
      if params[:time4]
        times.push(params[:time4])
      end
    end
    if params[:remark]
      remark = params[:remark]
    else
      remark = nil
    end
    @entry = Entry.new(
      user_id: @current_user.id,
      event_id: event.id,
      entry_type: event.event_type,
      regular_band_id: r_band_id,
      temporal_band_id: t_band_id,
      message: params[:message],
      musics: musics,
      times: times,
      remark: remark
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
		@entries = @event.entries.order(:created_at)
	end
  def entry_admin_list
  end

  def contact_top
    @contact = Contact.new
  end

  def contact_send
    @contact = Contact.new(
      user_id: @current_user.id,
      content: params[:content],
      )
    if @contact.save
      flash[:notice] = "送信されました"
      redirect_to('/submit/contact')
      UserMailer.contact_form_mail(@contact).deliver
    else
      flash[:notice] = "送信できませんでした。再度試してください"
      render('submit/contact_top')
    end
  end
end
