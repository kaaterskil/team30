FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    known_by { Faker::Name.first_name}
    birth_date { rand(25..65).years.ago(Date.today) }
    gender { User::GENDER.sample }
    height { rand(59..72) }
  end

  factory :team do
    name { Faker::Company.name }
    is_active true
  end
end
