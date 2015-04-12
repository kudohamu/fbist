# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rank do
    sequence(:no) { |i| i }
    sequence(:rank) { |i| "A#{i}" }
  end
end
