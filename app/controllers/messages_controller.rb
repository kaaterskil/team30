class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.where('user_id = ?', params[:user_id])
  end

  def new
    @message = Message.new
    @user = User.find(params[:user_id])
    @users = User.joins(:teams).
              joins('INNER JOIN rosters r2 ON teams.id = r2.team_id').
              where('r2.user_id = ?', @user.id)
  end

  def create
    @message = Message.new(message_params)
    if @message.valid? && @message.save
      flash[:success] = 'Team updated.'
      redirect_to user_path(params[:sender_id])
    else
      flash[:alert] = 'Error: ' + @message.errors.full_messages.join(', ')
      render :back
    end
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :team_id, :thread_id, :content, :is_private)
  end
end
