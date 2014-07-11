class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_teammates, except: :index

  def index
    @messages = current_user.messages
  end

  def new
    @message = Message.new
    @user = current_user
  end

  def create
    @message = Message.new(message_params)
    @message.send_message(current_user.id, message_params[:recipient_id])
    if @message.errors.empty?
      redirect_to user_path
    else
      flash[:alert] = @message.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  private

  def get_teammates
    @users = current_user.get_teammates
  end

  def message_params
    params.require(:message).permit(:user_id, :sender_id, :recipient_id, :team_id, :thread_id, :content, :is_private, :sent)
  end
end
