# Represents a registered user (dieter) in the application
class User < ActiveRecord::Base
  class UserNotAvailableException < RuntimeError; end
  class UserNotTeamLeaderException < RuntimeError; end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  GENDER = %w(Female Male)

  # Bidirectional many-to-one association, inverse side
  # For teams that the user manages as its leader
  has_many :managed_teams, foreign_key: :leader_id, class_name: 'Team'

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :teams, through: :rosters

  validates :known_by, :birth_date, :gender, :height, presence: true
  validates :gender, inclusion: { in: GENDER, message: "%{value} is not a valid gender" }
  validates :height, numericality: { only_integer: true, message: "%{value} is not an integer" }

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
    raise UserNotTeamLeaderException if !is_team_leader?(team)
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
end
