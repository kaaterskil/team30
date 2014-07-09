# Represents a registered user (dieter) in the application
class User < ActiveRecord::Base
  class UserNotAvailableException < RuntimeError; end
  class UserNotTeamLeaderException < RuntimeError; end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  GENDER = %w(Female Male)

  # Bidirectional one-to-many  association, inverse side
  # For teams that the user manages as its leader
  has_many :managed_teams, foreign_key: :leader_id, class_name: 'Team'

  # Bidirectional one-to-many associations, inverse side
  has_many :exercises, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :weigh_ins, dependent: :destroy
  has_many :messages, dependent: :destroy

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :teams, through: :rosters

  validates :known_by, :birth_date, :gender, :height, presence: true
  validates :gender, inclusion: { in: GENDER, message: "%{value} is not a valid gender" }
  validates :height, numericality: { only_integer: true, message: "%{value} is not an integer" }

  # ---------- Methods ---------- #

  # Returns true if this user is available to join a team, false otherwise.
  # In other words, the method returns true if this user is not assigned
  # to a team that is no longer active.
  def available?
    teams.where(is_active: true).empty?
  end

  # Creates a new team from the given paramters and assigns the user to the
  # team. An exception is thrown if the new team is invalid.
  #
  # params - a hash of parameters required to create a team
  #
  # Returns a new Team object that has been instantiated with the given
  # attributes, linked to this user and that has already been saved
  # (if it passes the validations).
  def create_team(params)
    team = managed_teams.create!(params)
    team.users << self
    team
  end

  # Adds the given user to the given team if a) this user is the team leader
  # and b) if the challenge has not started yet and c) the given user isn't
  # already a team member.
  #
  # user - the user to add
  # team - the team to assign to the user
  #
  # Returns true on success, false otherwise.
  def add_user_to_team(team, user)
    # raise UserNotTeamLeaderException if !is_team_leader?(team)
    raise Team::TeamInProgressError if team.is_in_progress?
    raise Team::TeamIsClosedError if team.is_closed?
    raise UserNotAvailableException if !user.available?

    team.users << user
    user.save
    true
  end

  # Deletes the row with a primary key matching the id argument, using a
  # SQL DELETE statement.
  #
  # team - the team from which to remove the given user
  # user = the user to remove
  #
  # Returns the number of rows deleted
  def remove_user_from_team(team, user)
    raise UserNotTeamLeaderException if !is_team_leader?(team)

    team.users.delete(user.id).size
  end

  # Starts the given team's challenge if this user is the team leader and
  # the challenge has not already been started.
  #
  # team - the team to start
  #
  # Returns true on success, false otherwise
  def start_challenge(team)
    raise UserNotTeamLeaderException if !is_team_leader?(team)
    raise Team::TeamInProgressError if team.is_in_progress?
    raise Team::TeamIsClosedError if team.is_closed?
    raise Team::TeamHasUncommittedMembersError if !team.can_start_challenge?

    team.starting_on = Date.today
    team.ending_on = 30.days.from_now
    team.is_active = true
    team.save
    true
  end

  # Tests if this user is the given team's leader.
  #
  # team - the team to test its leader
  #
  # Returns true if this user is the given team's leader, false otherwise.
  def is_team_leader?(team)
    managed_teams.include?(team)
  end

  # Returns a hash of daily calorie differentials from target, in percent,
  # by team. The hash key is the team name and the value is an aray of the
  # daily results.
  def fetch_data
    result = {}
    teams.each { |team| result[team.name] = fetch_team_data(team) }
    result
  end

  # Returns an array of daily calorie differentials from target, in percent.
  def fetch_team_data(team)
    data = []
    (0..30).each do |i|
      if !team.starting_on.nil?
        challenge_date = team.starting_on + i.days
        data[i] = get_daily_performance(team, challenge_date)
      else
        data[i] = 0.00
      end
    end
    data
  end

  # Returns the calorie differential from target, in percentage terms, for
  # the given challlenge date
  def get_daily_performance(team, challenge_date)
    target = rosters.sum(:target_calories_per_day).
      where('team_id = ?', team.id)
    calories_from_meals = meals.join().sum(:total_calories).
      where('team_id = ? and meal_date = ?', team.id, challenge_date)
    calories_from_exercise = exercises.sum(:total_calories).
      where('team_id = ? and entry_date = ?', team.id, challenge_date)
    calories_from_weigh_ins = weigh_ins.sum(:total_calories).
      where('team_id = ? and entry_date = ?', team.id, challenge_date)
    total_calories = calories_from_meals - calories_from_exercise + calories_from_weigh_ins
    (total_calories - target) / target
  end
end
