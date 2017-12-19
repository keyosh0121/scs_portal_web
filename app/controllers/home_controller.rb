class HomeController < ApplicationController

  def top
    if @current_user
      redirect_to('/user/#{@current_user.id}/show')
    end
  end

  def login
  end

end
