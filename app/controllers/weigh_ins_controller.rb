class WeighInsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_weigh_in, except: [:index, :new, :create]

  def index
    @weigh_ins = current_user.weigh_ins.order('entry_date DESC')
  end

  def create
    @weigh_in = current_user.weigh_ins.new(weigh_in_params)
    @weigh_in.team_id = current_user.fetch_active_team
    @weigh_in.total_calories = current_user.weigh_in(@weigh_in)
    if @weigh_in.valid? && @weigh_in.save
      redirect_to weigh_ins_path, notice: 'Weigh-in saved.'
    else
      flash[:alert] = @weigh_in.errors.full_messages.join(', ')
      render :new
    end
  end

  def new
    @weigh_in = WeighIn.new
  end

  def edit
  end

  def update
    @weigh_in.assign_attributes(weigh_in_params)
    @weigh_in.total_calories = current_user.weigh_in(@weigh_in)
    if @weigh_in.valid? && @weigh_in.save
      redirect_to weigh_ins_path, notice: 'Weigh-in updated.'
    else
      flash[:alert] = @weigh_in.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @weigh_in.destroy!
    redirect_to weigh_ins_path, notice: 'Weigh-in deleted.'
  end

  private

  def find_weigh_in
    @weigh_in = WeighIn.find(params[:id])
  end

  def weigh_in_params
    params.require(:weigh_in).permit(:entry_date, :total_calories, :measured_weight)
  end

end
