# Team30

This web application provides team-driven motivation to help you manage your diet. Set weight and calorie goals at the individual and team level and track your progress over a 30 day cycle. See how your actual diet habits compare to your goals as well as your teammates and other teams, and forecast your ability to meet your objectives. Help keep your teammates' spirits up and their attention focused through private messages.

# User Stories:
## Team/Individual Setup:

  1. A user must register and login to the site in order to join a team and use the challenge functions.
  2. Each user can enter their initial information: name, gender, height, and age (birth date).
  3. Any user can create a team and add existing users to it. A user can only belong to one team at a time.
  4. Once assigned to a team roster, the user enters their current weight (in lbs) and expected general activity level (sedentary, light-active, active, very active) for the 30-day challenge.
  5. The application computes the user's BMR (Basal Metabolic Rate) and TDEE (Total Daily Energy Expenditure) in calories based on the user's input data.
  6. Each user sets their individual weight loss goal. From the BMR and TDEE, the application computes the user's daily calorie intake required to reach their desired weight over 30 days.
  7. A user can edit their target weight (recomputing the daily calorie intake) but, once committed, the goal is fixed and cannot be changed over the 30 day challenge.
  8. The user's starting weight, target weight and required daily calorie intake are added to the team.
  9. The team leader initiates the start of the 30-day challenge. A challenge cannot start until all team members commit their goals.

## The 30-day Challenge:

  1. The user can create daily meals (breakfast, lunch, dinner, snack). Multiple meals of the same type in a single day are allowed. Each meal has one or more servings - query terms are sent to the API via the ruby gem, which returns a list of matches from which to select. (See https://developer.nutritionix.com/docs/v1_1. ) The API responds to queries for restaurant menu items, packaged food or raw goods. Each selected item has a calorie count.
  2. Serving calories are totaled by meal, individual, and team by day.
  3. Users can enter calories expended in exercise above their stated activity level. These are subtracted from the day's calorie intake.
  4. Users can enter their actual weight. The application will convert pounds to calories as an adjustment to the user's running calorie total.
  5. Results are displayed on a time-line as a daily percent deviation from the computed goal (in order to normalize results between large and small teams), for both individual users and teams.
  6. Cumulative progress toward the goal is indicated for the user and team.
  7. Users may post messages to other team members, either individually or to the team as a whole. Messages can be private. This is an internal message area and does not involve email or other public chat or message services.
  8. OPTIONAL FEATURE: Based on trending, a forecast is computed for the end of the challenge and presented as percent deviation from goal, also by user and team.

## Challenge Completion/Renewal:

  1. The application shows final statistics.
  2. OPTIONAL FEATURE:  The application prompts the team leader to renew the challenge. If renewed, the application creates a "parent team" from the team's meta information if the team doesn't already belong to a parent and stores the current challenge as a "child" to the parent. The application creates a new "child" challenge. Statistics continue to be added to the parent as the new challenge progresses.

## Additional Specifications:

  1. All user data is private.
  2. A user's initial criteria (gender, age, height, starting weight, activity level, or target weight) cannot be edited while a team is in progress.

