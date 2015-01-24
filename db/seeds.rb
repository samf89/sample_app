puts "Emptying User table"
User.delete_all

puts "Creating Example User"
User.create!( name: "Example User",
              email: "example@railstutorial.org",
              password: '123456',
              password_confirmation: '123456',
              admin: true,
              activated: true,
              activated_at: Time.now )

puts "Creating the other 99 users"
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  User.create!( name: name, 
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.now  )
end
