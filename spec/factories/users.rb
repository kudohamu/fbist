# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "fbist#{i}" }
    sequence(:email) { |i| "hogehoges#{i}@gmail.com" }
    password "hogehoge"
    password_confirmation "hogehoge"
    is_baned true
    uid SecureRandom.uuid
  end
end
