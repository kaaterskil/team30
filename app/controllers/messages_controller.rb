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
              where('r2.user_id = ? AND users.id != ?', @user.id, @user.id)
  end

  def create
    @message = Message.new(message_params)
    @message.send_message(current_user.id, params(:recipient_id))
    redirect_to :back
  end

  private

  def message_params
    params.require(:message).permit(:recipient_id, :team_id, :thread_id, :content, :is_private)
  end
end
