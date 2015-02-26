# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gundam do
    icon File.open(File.join(Rails.root, "app/assets/images/test.jpg"))
    sequence(:name) { |i| "hoge#{i+1}ガンダム" }
    sequence(:no) { |i| i+1 }
    sequence(:wiki) { |i| "hoge#{i}.html" }
    cost
  end
end
