class Team < ActiveRecord::Base
  class TeamInProgressError < RuntimeError; end
  class TeamIsClosedError < RuntimeError; end
  class TeamHasUncommittedMembersError < RuntimeError; end
  class TeamNotStartedError < RuntimeError; end

  # Bidirectional many-to-one association: owning side
  # To team leader
  belongs_to :leader, class_name: "User"

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :users, through: :rosters

  # Bidirectional one-to-many associations, inverse side
  has_many :exercises
  has_many :meals
  has_many :weigh_ins

  validates :name, presence: true

  # ---------- Methods ---------- #

  # Returns trus if the team starting date is set the ending date has not
  # been reached, false otherwise.
  def is_in_progress?
    return starting_on && ending_on >= Date.today
  end

  # Returns true if the team ending date has passed, false otherwise.
  def is_closed?
    return !is_active
  end

  # Returns the team's current status.
  def status
    if starting_on.nil?
      'Getting Organized'
    elsif is_in_progress?
      'In Progress'
    elsif !is_active
      'Closed'
    else
      'Unknown'
    end
  end

  # Returns a collection of public messages sent by all team members.
  def messages
    Message.joins('INNER JOIN users u ON messages.sender_id = u.id').
    joins('INNER JOIN rosters r ON r.user_id = u.id').
    where('r.team_id = ? AND is_private = false AND sent = true', id).
    order('messages.created_at DESC')
  end

  # Returns the number of days into the challenge, or zero if the challenge
  # has not started. Returns 'Closed' if the challenge is closed.
  def day_no
    today = Date.today
    if starting_on && (ending_on > today}
      (today - starting_on + 1).days.to_s
    end
    is_active ? 0 : 'Closed'
  end

  # Returns true if all team members have committed to their individual plan
  # and a challenge can be started, false otherwise. A TeamInProgressError is
  # raised if the challenge has already started.
  def can_start_challenge?
    rosters.where(is_record_locked: false).size == 0
  end

  # Returns an array of daily calorie differentials from target, in percent.
  def fetch_data
    data = []
    (0..30).each do |i|
      if starting_on
        challenge_date = starting_on + i.days
        data[i] = get_daily_performance(challenge_date)
      else
        data[i] = 0.00
      end
    end
    data
  end

  # Returns the calorie differential from target, in percentage terms, for
  # the given challlenge date
  def get_daily_performance(challenge_date)
    target = rosters.sum(:target_calories_per_day)
    calories_from_meals = meals.where('meal_date = ?', challenge_date).sum(:total_calories)
    calories_from_exercise = exercises.where('entry_date = ?', challenge_date).sum(:total_calories)
    calories_from_weigh_ins = weigh_ins.where('entry_date = ?', challenge_date).sum(:total_calories)
    total_calories = calories_from_meals - calories_from_exercise + calories_from_weigh_ins
    (total_calories > 0) ? ((total_calories - target) / target * 100) : 0
  else
  end
end
