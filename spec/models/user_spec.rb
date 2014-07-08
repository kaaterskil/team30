require 'date'
require 'spec_helper'
require_relative '../../app/models/user'
require_relative '../../app/models/team'

describe User do
  describe '#create_team' do
    it 'can create a team from given paramters' do
      user = create :user
      user.create_team(attributes_for(:team))
      team = user.managed_teams.first

      expect(user.managed_teams.size).to eq 1
      expect(user.is_team_leader?(team)).to eq true
    end
  end

  describe '#is_team_leader' do
    it 'can test if it is the given team\'s leader' do
      user = create :user
      user.create_team(attributes_for(:team))
      team1 = user.managed_teams.first
      team2 = create :team

      expect(user.managed_teams.size).to eq 1
      expect(user.is_team_leader?(team1)).to eq true
      expect(user.is_team_leader?(team2)).to eq false
      expect(team1.leader_id).to eq user.id
      expect(team2.leader_id).to eq nil
    end
  end

  describe '#add_user_to_team' do
    it 'cannot add a user if the user is unavailable' do
      leader = create :user
      team = leader.create_team(attributes_for(:team))
      user = create :user
      leader.add_user_to_team(team, user)
      team2 = leader.create_team(attributes_for(:team))

      expect(user.available?).to eq false
      expect{ leader.add_user_to_team(team2, user) }.to raise_error User::UserNotAvailableException
    end

    it 'cannot add a user if the team challenge is in progress' do
      leader = create :user
      team = leader.create_team(attributes_for(:team))
      user = create :user
      leader.add_user_to_team(team, user)

      team.rosters.each { |e| e.commit_to_goals }
      leader.start_challenge(team)

      expect{ leader.add_user_to_team(team, user) }.to raise_error Team::TeamInProgressError
    end

    it 'can add a user of the user is available and the challenge has not started' do
      leader = create :user
      team = leader.create_team(attributes_for(:team))
      user = create :user

      expect(leader.add_user_to_team(team, user)).to eq true
    end
  end

  describe '#remove_user_from_team' do
    it 'can remove a user' do
      leader = create :user
      team = leader.create_team(attributes_for :team)
      user = create :user
      leader.add_user_to_team(team, user)

      expect(leader.remove_user_from_team(team, user)).to eq 1
    end
  end

  describe '#start_challenge' do
    it 'cannot start a challenge if the challenge has already started' do
      leader = create :user
      team = leader.create_team(attributes_for :team)
      leader.rosters.find_by(team_id: team.id).commit_to_goals
      leader.start_challenge(team)

      expect{ leader.start_challenge(team) }.to raise_error Team::TeamInProgressError
    end

    it 'cannot start a challenge if team members haven\'t committed' do
      leader = create :user
      team = leader.create_team(attributes_for :team)
      user = create :user
      leader.add_user_to_team(team, user)

      expect{ leader.start_challenge(team) }.to raise_error Team::TeamHasUncommittedMembersError
    end

    it 'can start a challenge if it isn\'t already started and members have committed' do
      leader = create :user
      team = leader.create_team(attributes_for :team)
      user = create :user
      leader.add_user_to_team(team, user)
      team.rosters.each { |e| e.commit_to_goals }

      expect(leader.start_challenge(team)).to eq true
    end
  end
end
