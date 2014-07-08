# Represents a registered user (dieter) in the application
class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  GENDER = %w(Female Male)

  # Bidirectional many-to-one association, inverse side
  has_many :managed_teams, foreign_key: :leader_id, class_name: 'Team'

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :teams, through: :rosters

  validates :known_by, :birth_date, :gender, :height, presence: true
  validates :gender, inclusion: { in: GENDER, message: "%{value} is not a valid gender" }
  validates :height, numericality: { only_integer: true, message: "%{value} is not an integer" }

  # Adds the given user to the given team if this user id the team leader and
  # if the challenge has not started yet and the given user isn't already a
  # team member.
  #
  # user - the user to add
  # team - the team to assign to the user
  #
  # Returns true on success, false otherwise.
  def add_user_to_team(team, user)
    if is_team_leader?(team)
      today = Date.today
      if (team.starting_on.nil? || team.starting_on > today)
        return team.users << user if !team.users.include?(user)
      end
    end
    false
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
