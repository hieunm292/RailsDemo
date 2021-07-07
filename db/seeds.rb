User.create!(name: "Foobar",
             email: "foobar@gmail.com",
             password: "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "foobarbar"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
  end
