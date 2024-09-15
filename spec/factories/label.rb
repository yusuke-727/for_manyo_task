FactoryBot.define do
    factory :label do
      name { "Test Label" }
      association :user
    end
  end
  