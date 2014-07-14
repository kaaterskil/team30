require 'factory_girl'

User.delete_all
Team.delete_all
Roster.delete_all
Ingredient.delete_all
Meal.delete_all
Exercise.delete_all
WeighIn.delete_all
Message.delete_all

natasha = FactoryGirl.create :user,
            email: 'natasha@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Natasha',
            gender: 'Female'

marcus = FactoryGirl.create :user,
            email: 'marcus@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Marcus',
            gender: 'Male'

alec = FactoryGirl.create :user,
            email: 'alec@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Alec',
            gender: 'Female'

jaye = FactoryGirl.create :user,
            email: 'jaye@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Jaye',
            gender: 'Male'

peter = FactoryGirl.create :user,
            email: 'peter@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Peter',
            gender: 'Male'

juliana = FactoryGirl.create :user,
            email: 'juliana@example.com',
            password: 'password',
            password_confirmation: 'password',
            known_by: 'Juliana',
            gender: 'Female'

tufsT1 = natasha.create_team(name: 'Tufts T1')

natasha.add_user_to_team(tufsT1, juliana)
natasha.add_user_to_team(tufsT1, alec)
