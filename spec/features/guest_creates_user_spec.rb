require 'rails_helper'

feature 'Guest creates user' do
  scenario 'successfully' do
    visit root_path

    click_link 'Sign Up'
    fill_in 'Email', with: 'kate@eventsinc.net'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    fill_in 'Name', with: 'Katy'
    fill_in 'Birth Date', with: '08-05-1953'
    select 'Female', from: 'Gender'
    fill_in 'Height (in inches)', with: '60'
    click_button 'Sign Up'

    expect(page).to have_content 'hello Katy'
  end
end

