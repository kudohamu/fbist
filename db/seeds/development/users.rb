User.create(
  id: 1,
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
