class SubmitController < ApplicationController

  def mic
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
    @mic = Mic.new(
      band: params[:band],
      sender: @current_user.name,
      date: params[:date],
      time: params[:time],
      paattendance: attendance
      )
    params[:paattendance]
    if @mic.save
      redirect_to("/user/#{session[:user_id]}/show")
    else
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      render("/submit/mic")
    end
  end

  def comment
    self.user_authentificate
  end

  def comment_conference
    self.user_authentificate
    @conferences = Conference.all
    @object1 = params[:object1]
    @conference = Conference.find_by(name:@object1)
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
      year: Date.today.year
      #  ----------------------------image
      )
    if @band.save
      redirect_to("/user/#{session[:user_id]}/show")
    else
      flash[:notice] = "保存に失敗しました。入力内容を確認してください。"
      render("submit/regular_band")
    end
  end

  def temporal_band
    self.user_authentificate
    @temporal_band = TemporalBand.new()
    @events = Event.all
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
    self.user_authentificate

  end

  def show_infos
    self.user_authentificate
  end

  def add_infos
    self.user_authentificate
  end

end
