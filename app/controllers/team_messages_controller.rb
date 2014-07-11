class TeamMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_team

  def index
    @messages = @team.messages
    render 'messages/team_index'
  end

  def new
    @message = Message.new
    @users = @team.users.where('users.id != ?', current_user.id)
    render 'messages/new'
  end

  def create
    @message = Message.new(message_params)
    @message.send_message(current_user.id, params[:recipient_id])
    if !@message.errors.empty?
      flash[:alert] = @message.errors.full_messages.join(', ')
    end
    redirect_to team_messages_path
  end

  private

  def find_team
    @team = Team.find(params[:team_id])
  end

  def message_params
    params.require(:message).permit(:user_id, :sender_id, :recipient_id, :team_id, :thread_id, :content, :is_private, :sent)
  end
end
