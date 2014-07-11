class IngredientsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_meal, only: [:create, :destroy]

  def create
    @ingredient = @meal.ingredients.new(
      user_id: current_user.id,
      team_id: @meal.team_id,
      meal_date: @meal.meal_date,
      item_id: params[:item_id],
      item_description: params[:item_description],
      calories: params[:calories].to_i
    )
    if !@ingredient.valid? || !@ingredient.save
      flash[:alert] = @ingredient.errors.full_messages.join(', ')
    end
    redirect_to meal_path(@meal.id)
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy!
    redirect_to meal_path(@meal.id)
  end

  private

  def find_meal
    @meal = Meal.find(params[:meal_id])
  end

  def food_params
    # Cannot implement #require() since this is a #form_tag() form.
    params.permit(:calories, :item_description, :item_id)
  end
end
