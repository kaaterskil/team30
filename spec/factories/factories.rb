FactoryGirl.define do
  factory :team do
    leader_id { rand(1..100) }
    name { Faker::Company.name }
    starting_on { rand(0..60).days.ago(Date.today) }
    ending_on { starting_on + 30.days }
  end
end
