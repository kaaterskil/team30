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
    if @user.valid? && @user.update
      flash[:success] = 'User updated'
      redirect_to user_path(params[:id])
    else
      flash[:alert] = @user.messages.full_messages.join(', ')
      render :edit
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:birth_date, :height, :gender, :known_by)
  end
end
