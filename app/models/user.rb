require 'groupdate'

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

  # Returns all users who have been/are teammates of this user.
  def get_teammates
    User.joins(:teams).
      joins('INNER JOIN rosters r2 ON teams.id = r2.team_id').
      where('r2.user_id = ? AND users.id != ?', id, id)
  end

  # Returns the roster for the given team, or nil if the user is
  # not a member of the given team.
  def get_roster(team)
    self.rosters.find_by_team_id(team.id)
  end

  # Returns true if this user is available to join a team, false otherwise.
  # In other words, the method returns true if this user is not assigned
  # to a team that is no longer active.
  def available?
    teams.where(is_active: true).empty?
  end

  # Creates a new team from the given paramters and assigns the user to the
  # team. An exception is thrown if the new team is invalid.
  #
  # @param params - a hash of parameters required to create a team
  #
  # @eturn A new Team object that has been instantiated with the given
  #        attributes, linked to this user and that has already been saved
  #        (if it passes the validations).
  def create_team(params)
    team = managed_teams.create!(params)
    team.users << self
    team
  end

  # Returns users who are not members of the given team.
  #
  # @param team The team to exclude
  #
  # @return A collection of non-team members.
  def non_team_members(team)
    User.joins('LEFT OUTER JOIN rosters r ON users.id = r.user_id').
      joins('LEFT OUTER JOIN teams t ON r.team_id = t.id').
      where('(t.id != ? OR t.id IS NULL) AND users.id != ?', team.id, self.id).
      order('users.known_by')
  end

  # Adds the given user to the given team if a) this user is the team leader
  # and b) if the challenge has not started yet and c) the given user isn't
  # already a team member.
  #
  # @param user - the user to add
  # @param team - the team to assign to the user
  #
  # @return True on success, false otherwise.
  def add_user_to_team(team, user)
    # raise UserNotTeamLeaderException if !is_team_leader?(team)
    raise Team::TeamInProgressError if team.is_in_progress?
    raise Team::TeamIsClosedError if team.is_closed?
    raise UserNotAvailableException if !user.available?

    team.users << user
    team.save!
    user.save!
    true
  end

  # Deletes the row with a primary key matching the id argument, using a
  # SQL DELETE statement.
  #
  # @param team - the team from which to remove the given user
  # @param user = the user to remove
  #
  # @return The number of rows deleted
  def remove_user_from_team(team, user)
    raise UserNotTeamLeaderException if !is_team_leader?(team)

    team.users.delete(user.id).size
  end

  # Starts the given team's challenge if this user is the team leader and
  # the challenge has not already been started.
  #
  # @param team - the team to start
  #
  # @return True on success, false otherwise
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
  # @param team - the team to test its leader
  #
  # @return True if this user is the given team's leader, false otherwise.
  def is_team_leader?(team)
    managed_teams.include?(team)
  end

  # Returns the current active team, or nil if none exists.
  def fetch_active_team
    teams.find_by('is_active = ?', true)
  end

  # Returns a data adjustment representing the differential between the
  # computed weight of the user at the given weigh-in date and the actual,
  # in calories.
  #
  # @param weigh_in The WeighIn object to assess
  #
  # @returns the differential between actual and computer weight, in calories,
  # as of the end of the day before the weigh-in.
  def weigh_in(weigh_in)
    target_intake = rosters.select('target_calories_per_day').
                            where('team_id = ?', team.id)
    team = user.fetch_active_team
    roster = current_user.rosters.where('team_id = ?', team.id)

    starting_weight = roster.starting_weight
    net_calorie_intake = fetch_team_data(team).map { |k, v|
       (v - target_intake) if k < weigh_in.entry_date
    }.reduce(&:+)
    computed_weight = starting_weight - (net_calorie_intake / 3500)

    (weigh_in.measured_weight - computed_weight) * 3500
  end

  # Returns a hash of daily calorie differentials from target, in percent,
  # by team. The hash key is the team name and the value is an aray of the
  # daily results.
  def fetch_data
    result = {}
    teams.each { |team| result[team] = fetch_team_data(team) }
    result
  end

  # Returns daily percentage deviation from target calorie intake.
  #
  # @param team The team to compute statistics
  #
  # @returns An array where keys correspond to the 30 day challenge dates, and
  # values are the net deviations, in percent.
  def fetch_team_stats(team)
    target_intake = rosters.select('target_calories_per_day').
                            where('team_id = ?', team.id)
    fetch_team_data.values.map{ |v| (v - target_intake) / target_intake }
  end

  # Returns daily net actual calorie intake. Note: this method uses the
  # 'groupdate' gem.
  #
  # @param team The team to compute statistics
  #
  # @returns A hash where keys correspond to the 30 day challenge dates, and
  # values are the net meals, exercise and weigh-in adjustments, in calories.
  def fetch_team_data(team)
    # Fetch daily totals from meals, exercies and weigh-ins
    meals_cals = meals.where('team_id = ?', team.id).
                       group_by_day(:meal_date).sum(:total_calories)
    exercise_cals = exercises.where('team_id = ?', team.id).
                              group_by_day(:entry_date).sum(:total_calories)
    weigh_in_cals = weigh_ins.where('team_id = ?', team.id).
                              group_by_day(:entry_date).sum(:total_calories)

    # Initialize a hash with 30 elements whose keys are dates beginning
    # with the starting date
    key_date = team.starting_on ? team.starting_on : Date.today
    data = {}
    (0..30).each do |i|
      key_date = key_date + i.days
      data[key_date] = 0.00
    end

    # Assigns the net actual calorie intake to the corresponding key.
    data.each do |key_date, value|
      value = meals_cals[key_date] if !meals_cals[key_date].nil?
      value -= exercise_cals[key_date] if !exercise_cals[key_date].nil?
      value += weigh_in_cals[key_date] if !weigh_in_cals[key_date].nil?
    end
    data
  end
end
