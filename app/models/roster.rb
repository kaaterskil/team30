class Roster < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  # Commits the user to the goals in this roster. The method does nothing
  # if the user has already committed.
  def commit_to_goals
    toggle(:is_record_locked)
    self.save
  end
end
