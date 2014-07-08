require 'date'
require 'spec_helper'
require_relative '../../app/models/user'
require_relative '../../app/models/team'

describe User do
  describe '#is_team_leader' do
    it 'can test if it is the given team\'s leader' do
      user = create :user
      team1 = create :team
      user.managed_teams.push(team1)
      team2 = create :team

      expect(user.managed_teams.size).to eq 1
      expect(user.is_team_leader?(team1)).to eq true
      expect(user.is_team_leader?(team2)).to eq false
      expect(team1.leader_id).to eq user.id
      expect(team2.leader_id).to eq nil
    end
  end

  describe '#add_user_to_team' do
    it 'can add a user to a managed team' do
      leader = create :user
      user = create :user
      teams = create_list(:team, 2)
      teams[0].starting_on = nil
      teams[0].ending_on = nil
      leader.managed_teams << teams[0]

      expect(leader.add_user_to_team(teams[0], user)).to_not eq false
      expect(leader.add_user_to_team(teams[1], user)).to eq false
    end
  end
end
