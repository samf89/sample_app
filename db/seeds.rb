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

puts "Creating microposts for the first 6 users"
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

puts "Creating Relationships"
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
