# Respresents a team of registered users (dieters)
class TeamsController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    @teams = Team.all
  end

  private
end
