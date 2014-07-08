require 'date'
require 'spec_helper'
require_relative '../../app/models/roster'
require_relative '../../app/models/user'
require_relative '../../app/models/team'

describe Roster do
  describe '#set_goals' do
    it 'sets the user\'s goals' do
      leader = create :user
      team = leader.create_team(attributes_for :team)
      user = create(:user, height: 60, gender: 'Female', birth_date: '1953-08-05')
      leader.add_user_to_team(team, user)
      roster = user.rosters.find_by(user_id: user.id)
      roster.starting_weight = 126
      roster.target_weight = 120
      roster.activity_level = 'Sedentary'
      roster.set_goals

      expect(roster.target_calories_per_day).to eq 1205
    end
  end
end
