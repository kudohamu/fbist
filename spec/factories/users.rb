# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) { |i| "testuser#{i}" }
    sequence(:email) { |i| "s#{SecureRandom.uuid}@gmail.com" }
    icon File.open(File.join(Rails.root, "app/assets/images/test.jpg"))
    password "hogehoge"
    password_confirmation "hogehoge"
    is_baned false
    sequence(:provider) { |i| "#{i}#{i}" }
    uid SecureRandom.uuid
  end
end
