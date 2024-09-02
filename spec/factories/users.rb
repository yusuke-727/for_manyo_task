FactoryBot.define do
    factory :user do
        name { "Test User" }
        email { Faker::Internet.unique.email }
        password { "password" }
        password_confirmation { "password" }
        admin { false }
      end
      
  
    factory :admin_user, class: 'User' do
      name { "Admin User" }
      email { "admin@example.com" }
      password { "password" }
      password_confirmation { "password" }
      admin { true }
    end
  end
  