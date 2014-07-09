require 'factory_girl'

User.delete_all
Team.delete_all
Roster.delete_all

leader1 = FactoryGirl.create :user
team1 = leader1.create_team(FactoryGirl.attributes_for(:team))
user1 = FactoryGirl.create :user
leader1.add_user_to_team(team1, user1)
user2 = FactoryGirl.create :user
leader1.add_user_to_team(team1, user2)
user3 = FactoryGirl.create :user
leader1.add_user_to_team(team1, user3)

leader2 = FactoryGirl.create :user
team2 = leader2.create_team(FactoryGirl.attributes_for(:team))
user4 = FactoryGirl.create :user
leader2.add_user_to_team(team2, user4)
user5 = FactoryGirl.create :user
leader2.add_user_to_team(team2, user5)
user6 = FactoryGirl.create :user
leader2.add_user_to_team(team2, user6)

leader3 = FactoryGirl.create :user
team3 = leader3.create_team(FactoryGirl.attributes_for(:team))
user7 = FactoryGirl.create :user
leader3.add_user_to_team(team3, user7)
user8 = FactoryGirl.create :user
leader3.add_user_to_team(team3, user8)
