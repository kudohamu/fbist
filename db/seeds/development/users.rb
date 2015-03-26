User.create(
  id: 1,
  name: "すべて",
  icon: File.open(File.join(Rails.root, "app/assets/images/user_all.png")),
  uid: SecureRandom.uuid,
  provider: "",
  email: "all@gmail.com",
  password: "allall",
  password_confirmation: "allall"
)

User.create(
  id: 2,
  name: "その他",
  icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
  uid: SecureRandom.uuid,
  provider: "",
  email: "test@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)

User.create(
  name: "hogeuser",
  icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
  uid: SecureRandom.uuid,
  provider: "",
  email: "hoge@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)

User.create(
  name: "hugauser",
  icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
  uid: SecureRandom.uuid,
  provider: "",
  email: "huga@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)

User.create(
  name: "hageuser",
  icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
  uid: SecureRandom.uuid,
  provider: "",
  email: "hage@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)

users = %W(sunday monday tuesday wednesday thursday friday saturday)

users.each do |user|
  User.create(
    name: user,
    icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
    uid: SecureRandom.uuid,
    provider: "",
    email: "#{user}@gmail.com",
    password: user,
    password_confirmation: user
  )
end
