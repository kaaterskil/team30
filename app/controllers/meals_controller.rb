require_relative '../../lib/nutritionix/api_1_1'

class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_meal, except: [:index, :new, :create]
  before_action :set_user

  def index
    @meals = current_user.meals.order('meal_date DESC')
  end

  def create
    @meal = current_user.meals.new(meal_params)
    @meal.team_id = current_user.fetch_active_team.id
    if @meal.save
      redirect_to meal_path(@meal.id)
    else
      flash[:alert] = @meal.errors.full_messages.join(', ')
      render :new
    end
  end

  def new
    @meal = Meal.new
  end

  def edit
  end

  def show
    @ingredient = Ingredient.new
    @ingredients = @meal.ingredients

    @hits = nil
    if params[:query].present?
      app_id = ENV['API_ID']
      app_key = ENV['API_KEY']
      provider = Nutritionix::Api_1_1.new(app_id, app_key)
      search_params = nxql_search_params
      results_json = provider.nxql_search(search_params)
      results = JSON.parse(results_json)

      @hits = results['hits']
      @foods = create_foods(results['hits'])
    end
  end

  def update
    @meal.assign_attributes(meal_params)
    if @meal.valid? && @meal.save
      redirect_to meals_path
    else
      flash[:alert] = @meal.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    @meal.destroy!
    redirect_to meals_path
  end

  private

  def find_meal
    @meal = Meal.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def meal_params
    params.require(:meal).permit(:meal_date, :team_id, :meal_type, :total_calories)
  end

  def create_foods(hits)
    result = []
    hits.map do |e|
      fields = e['fields']
      result << ["#{fields['brand_name']} #{fields['item_name']}: (#{fields['nf_calories']} cals)", fields['item_id']]
    end
    result
  end

  def nxql_search_params
    fields = %w(brand_id brand_name item_id item_name nf_serving_size_qty nf_serving_size_unit)
    fields << %w(nf_calories nf_total_carbohydrate nf_sodium nf_dietary_fiber nf_protein)
    default_fields = fields.flatten

    {
      offset: 0,
      limit: 50,
      fields: default_fields,
      query: params[:query]
    }
  end
end
