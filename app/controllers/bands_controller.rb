class BandsController < ApplicationController
  before_action :set_band, only: [:edit, :update]

  def index
    @bands = Band.where(registration: true)
    @years = [Date.today.year, Date.today.year - 1, Date.today.year - 2, Date.today.year - 3]
    @bands_by_year = [@bands.where(year: @years[0]), @bands.where(year: @years[1]), @bands.where(year: @years[2]), @bands.where(year: @years[3])]
  end

  def show
    @band = Band.find(params[:id])
  end

  def new
    self.user_authentificate
    @band = Band.new()
    @names = User.all.map(&:name)
    @mem = []
    gon.names = @names
  end

  def create
    master_id = User.find_by(name:params[:master]).id if User.find_by(name:params[:master])
    if band_params[:year] == ""
      year = nil
    else
      year = band_params[:year].to_i
    end
    pa_id = User.find_by(name:params[:pa]).id if User.find_by(name:params[:pa])
    @band = Band.new(
      name: band_params[:name],
      pa_id: pa_id,
      master_id: master_id,
      description: band_params[:description],
      year: year,
      image: "default-band.jpg",
      website: band_params[:website],
      feature: band_params[:feature],
      band_type: 0
    )
    member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
    @mem = member_names
    error_counter = 0
    8.times do |i|
      key = ("member"+(i+1).to_s).to_sym
      if params[key] != "" && !User.find_by(name:member_names[i])
          error_counter += 1
      end
    end
    if band_params[:image]
      image = band_params[:image]
      @band.image = "#{@band.name}.jpg"
      File.binwrite("public/band-images/#{@band.image}", image.read)
    end
    if @band.save && error_counter == 0
      8.times do |i|
        BandMember.create(user_id: User.find_by(name: member_names[i]).id,band_id: @band.id,mic_number: i+1) if member_names[i] != ""
      end
      BandMailer.send_band_to_admin(@band).deliver
      redirect_to("/user/#{@current_user.id}/show")
      flash[:notice] = "正規バンドの申請を受け付けました"
    elsif error_counter > 0
        @names = User.all.map(&:name)
        flash[:notice] = "登録に失敗しました。#{error_counter}人の名前が登録されていません。"
        render :new
    else
      # puts @band.errors.full_messages
      @names = User.all.map(&:name)
      flash[:notice] = @band.errors.full_messages
      #redirect_to :action => "regular_band"
      render :new
    end
  end

  def edit
    @mem = []
    8.times do |i|
      if member = BandMember.find_by(band_id: @band.id, mic_number: i+1)
        @mem[i] = member.user.name
      else
        @mem[i] = ""
      end
    end
    @names = User.all.map(&:name)
    gon.names = @names
  end

  def update
    master_id = User.find_by(name:params[:master]).id if User.find_by(name:params[:master])
    if band_params[:year] == ""
      year = nil
    else
      year = band_params[:year].to_i
    end
    pa_id = User.find_by(name:params[:pa]).id if User.find_by(name:params[:pa])
    member_names = [params[:member1],params[:member2],params[:member3],params[:member4],params[:member5],params[:member6],params[:member7],params[:member8]]
    @mem = member_names
    #ユーザ存在確認
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

    if @band.update(
      name: band_params[:name],
      pa_id: pa_id,
      master_id: master_id,
      description: band_params[:description],
      year: year,
      website: band_params[:website],
      feature: band_params[:feature],
    ) && error_counter == 0
      8.times do |i|
        if BandMember.find_by(band_id: @band.id, mic_number: i+1)
          if member_names[i] == ""
            BandMember.find_by(band_id: @band.id, mic_number: i+1).delete
          else
            BandMember.find_by(band_id: @band.id, mic_number: i+1).update(user_id: User.find_by(name: member_names[i]).id)
          end
        elsif member_names[i] != ""
          BandMember.create(band_id: @band.id, user_id: User.find_by(name: member_names[i]).id, mic_number: i+1)
        end
      end
      BandMailer.send_band_information_change(@band).deliver
      redirect_to("/user/#{@current_user.id}/show")
      flash[:notice] = "#{@band.name}の情報を変更しました"
    elsif error_counter > 0
      @names = User.all.map(&:name)
      flash[:notice] = "登録に失敗しました。#{error_counter}人の名前が登録されていません。"
      render :edit
    else
      # puts @band.errors.full_messages
      @names = User.all.map(&:name)
      flash[:notice] = @band.errors.full_messages
      #redirect_to :action => "regular_band"
      render :edit
    end
    # binding.pry
  end

  def destroy
    @band = Band.find(params[:id])
    @name = @band.name
    if @band.destroy
      flash[:notice] = "#{@band.name}をデータベースから削除しました"
      BandMailer.send_band_destroy(@name).deliver
      redirect_to("/user/#{@current_user.id}/show")
    else
      flash[:notice] = "削除に失敗しました。再度試してください"
      redirect_to("/database/bands/detail/#{@band.id}")
    end
  end

  private
    def band_params
      # params.require(:)
      params.require(:band).permit(:name, :year, :website, :feature, :description, :image)
    end
    def set_band
      @band = Band.find(params[:id])
    end
end
