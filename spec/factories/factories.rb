FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    known_by { Faker::Name.first_name}
    birth_date { rand(20..60).years.ago(Date.today) }
    gender { User::GENDER.sample }
    height { rand(54..70) }
  end

  factory :team do
    name { Faker::Company.name }
    starting_on { rand(0..60).days.ago(Date.today) }
    ending_on { starting_on + 30.days }
  end
end
