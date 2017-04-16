FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'qwerty'
    name 'Chuck'
    balance 100
  end

  factory :account do
    bookmaker 'Bet365'
    age 1
    own true
    comment 'Lorem'
    status :opened
    association :user, factory: :user
  end

  factory :auction do
    current_price_cents 1000
    minimum_price_cents 1000
    final_price_cents 2000
    payment_type 0
    end_date Time.now + 10.days
    status :created
    association :user, factory: :user
    association :account, factory: :account
  end

  factory :bid do
    sequence(:stake_cents) { |n| 1000 + n*100 }
    association :user, factory: :user
    association :auction, factory: :auction
    status :active
  end
end