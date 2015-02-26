# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cost do
    sequence(:cost) { |i| i+1 }
  end
end
