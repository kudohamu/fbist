# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tmp_user do
    sequence(:name) { |i| "fbist#{i}" }
    password "hogehoge"
    password_confirmation "hogehoge"
    sequence(:mail) { |i| "hogehoge{i}@gmail.com" }
    is_baned true
  end
end
