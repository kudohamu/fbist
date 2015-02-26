User.create(
  id: 1,
  name: "kudohamu",
  icon: File.open(File.join(Rails.root, "app/assets/images/test.jpg")),
  uid: SecureRandom.uuid,
  email: "kudohamu@gmail.com",
  password: "hogehoge",
  password_confirmation: "hogehoge"
)
