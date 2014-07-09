class Roster < ActiveRecord::Base

  ACTIVITY_LEVEL = %w(Sedentary Light-Active Active Very-Active)

  belongs_to :user
  belongs_to :team

  # ---------- Methods ---------- #

  # Computes and saves the user's BMR and TDEE. If the user has set a target
  # weight, the method will compute and save the user's target calorie intake
  # goal per day over the life of the challenge,
  def set_goals
    return if is_record_locked

    compute_bmr
    compute_tdee
    if target_weight
      self.target_calories_per_day = tdee - ((starting_weight - target_weight) * 3500 / 30)
    else
      self.target_calories_per_day = tdee
    end
    self.save
  end

  # Commits the user to the goals in this roster. The method does nothing
  # if the user has already committed.
  def commit_to_goals
    return if is_record_locked

    toggle(:is_record_locked)
    self.save
  end

  # Returns the user's basal metabolic rate given the user's starting weight,
  # height, age and gender, in calories.
  def compute_bmr
    tmp = starting_weight * 4.53
    tmp += user.height * 15.87
    tmp += get_age * 4.92
    self.bmr = (user.gender == 'Female') ? (tmp - 161).to_i : (tmp + 5).to_i
  end

  # Computes the user's total daily energy expenditure, in calories.
  #
  # bmr - the user's basal metabloic rate (BMR)
  #
  # Returns the user's TDEE based on their expected activity level.
  def compute_tdee
    case activity_level
    when 'Sedentary' then tmp = 1.15
    when 'Light-Active' then tmp = 1.45
    when 'Active' then tmp = 1.7
    when 'Very-Active' then tmp = 1.9
    else tmp = 1
    end
    self.tdee = (bmr * tmp).to_i
  end

  # Returns the user's age
  def get_age
    now = Time.now.utc.to_date
    now.year - user.birth_date.year - (user.birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end
end
