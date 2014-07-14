class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def show
    @data = @user.fetch_data
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params)
    if @user.valid? && @user.save
      flash[:success] = 'User updated'
      redirect_to user_path
    else
      flash[:alert] = @user.messages.full_messages.join(', ')
      render :edit
    end
  end

  def start_team
    begin
      team = current_user.fetch_active_team
      @user.start_challenge(team)
    rescue Team::TeamInProgressError
      flash[:alert] = 'The team is already in progress.'
    rescue Team::TeamIsClosedError
      flash[:alert] = 'The team is closed.'
    rescue Team::TeamHasUncommittedMembersError
      flash[:alert] = 'There are uncommitted team members.'
    end
    redirect_to team_path(team)
  end

  private

  def find_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:birth_date, :height, :gender, :known_by)
  end
end
