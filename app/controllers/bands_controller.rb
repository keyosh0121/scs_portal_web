class BandsController < ApplicationController
  def index
    @bands = Band.where(registration: true)
  end

  def show
    @band = Band.find(params[:id])
  end
end
