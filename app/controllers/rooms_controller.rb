class RoomsController < ApplicationController
  def create
    room = Room.create!

    session[:room_id] = room.id
    session[:seat] = 1

    room.update!(host_joined: true)

    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])

    return if session[:seat].present?

    if @room.waiting? && @room.host_joined?
      session[:seat] = 2
      @room.update!(status: :playing)
    else
      redirect_to root_path
    end
  end

end