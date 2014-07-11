class ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_exercise, except: [:index, :new, :create]

  def index
    @exercises = current_user.exercises.order('entry_date DESC')
  end

  def create
    @exercise = current_user.exercises.new(exercise_params)
    @exercise.team_id = current_user.fetch_active_team
    if @exercise.valid? && @exercise.save
      redirect_to exercises_path, notice: 'Exercise saved.'
    else
      flash[:alert] = @exercise.errors.full_messages.join(', ')
      render :new
    end
  end

  def new
    @exercise = Exercise.new
  end

  def edit
  end

  def update
    @exercise.assign_attributes(exercise_params)
    if @exercise.valid? && @exercise.save
      redirect_to exercises_path, notice: 'Exercise updated.'
    else
      flash[:alert] = @exercise.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @exercise.destroy!
    redirect_to exercises_path, notice 'Exercise deleted.'
  end

  private

  def find_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:entry_date, :total_calories)
  end
end
