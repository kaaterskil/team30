class Team < ActiveRecord::Base
  class TeamInProgressError < RuntimeError; end
  class TeamIsClosedError < RuntimeError; end
  class TeamHasUncommittedMembersError < RuntimeError; end

  # Bidirectional one-to-many association: owning side
  # To team leader
  belongs_to :leader, class_name: "User"

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :users, through: :rosters

  validates :name, presence: true

  # Returns trus if the team starting date is set the ending date has not
  # been reached, false otherwise.
  def is_in_progress?
    return !starting_on.nil? && ending_on >= Date.today
  end

  # Returns true if the team ending date has passed, false otherwise.
  def is_closed?
    return !ending_on.nil? && ending_on < Date.today
  end

  # Returns true if all team members have committed to their individual plan
  # and a challenge can be started, false otherwise. A TeamInProgressError is
  # raised if the challenge has already started.
  def can_start_challenge?
    rosters.where(is_record_locked: false).size == 0
  end
end
