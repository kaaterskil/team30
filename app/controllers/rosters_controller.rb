class RostersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_roster

  def show
  end

  def edit
    redirect_to roster_path(@roster.id) if @roster.is_record_locked
  end

  def update
    @roster.assign_attributes(roster_params)
    @roster.set_goals
    if @roster.save && @roster.is_record_locked
      if @roster.starting_weight > 0 && @roster.target_weight > 0 && @roster.target_calories_per_day > 0
        render :show
      end
    else
      render :edit
    end
  end

  private

  def find_roster
    @roster = Roster.find(params[:id])
  end

  def roster_params
    params.require(:roster).permit(:user_id, :team_id, :starting_weight, :activity_level, :bmt, :tdee, :target_weight, :target_calories_per_day, :is_record_locked, :submit)
  end
end
