require 'rails_helper'

feature 'Guest views teams' do

  scenario 'on the front page' do
    teams = create_list(:team, 4)

    visit root_path

    teams.each do |team|
      expect(page).to have_content team.name
      expect(page).to have_content team.starting_on
      expect(page).to have_content team.ending_on
    end
  end
end
