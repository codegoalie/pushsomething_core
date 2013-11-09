FactoryGirl.define do
  factory :user do
    name 'Chris Marshall'
    sequence(:email) { |n| "person#{n}@example.com" }
  end

  factory :receiver do
    uid '12345'
    user
    gcm_id '54321'
    sequence(:nickname) { |n| "Recever #{n}" }
  end
end
