class TeamsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :find_team, only: [:edit, :show, :update, :destroy, :new_user, :add_user, :drop_user, :remove_user]

  def index
    @teams = Team.all
    fetch_data
  end

  def create
    begin
      @team = current_user.create_team(team_params)
    rescue
      flash[:alert] = 'Error: ' + @team.errors.full_messages.join(', ')
      render :back
    end
    flash[:success] = "Team #{@team.name} created. Now add your people!"
    redirect_to team_path(@team)
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def show
    @data = @team.fetch_data
    @users = @team.users
    fetch_team_data
  end

  def update
    @team.assign_attributes(team_params)
    if @team.valid? && @team.save
      flash[:success] = 'team updated.'
      redirect_to team_path(@team)
    else
      flash[:alert] = 'Error: ' + @team.errors.full_messages.join(', ')
      render :back
    end
  end

  def destroy
    @team.destroy!
    flash[:success] = 'Team deleted.'
    redirect_to teams_path
  end

  def new_user
    @users = current_user.non_team_members(@team)
  end

  def add_user
    user = User.find(team_params[:users])
    begin
      current_user.add_user_to_team(@team, user)
    rescue Team::TeamInProgressError
      flash[:alert] = 'Team is already in progress'
    rescue Team::TeamIsClosedError
      flash[:alert] = 'Team is closed'
    rescue User::UserNotAvailableException
      flash[:alert] = "#{user.known_by} is not available"
    end
    if !flash[:alert].nil?
      redirect_to team_path(@team.id)
    else
      render :new_user
    end
  end

  def drop_user
    @users = @team.users
  end

  def remove_user
    user = User.find(team_params[:users])
    @team.users.delete(user)
    user.save!
    @team.save!
    redirect_to team_path(@team.id)
  end

  private

  def find_team
    @team = Team.find(params[:id])
  end

  def fetch_data
    @data = {}
    @teams.each { |team| @data[team.id] = team.fetch_data }
  end

  def fetch_team_data
    @team_data = {}
    @team.users.each { |user| @team_data[user.id] = user.fetch_team_data(@team) }
  end

  def team_params
    params.require(:team).permit(:name, :starting_on, :ending_on, :is_target_weight_locked, :is_active, :users)
  end
end
