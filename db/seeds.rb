require 'faker'
require 'populator'

10.times do
  user = User.new
  user.username = Faker::Internet.user_name
  user.email = Faker::Internet.email
  user.password = "test"
  user.password_confirmation = "test"
  user.save
end

User.all.each do |user|
  Quote.populate(10) do |quote|
    quote.user_id = user.id
    quote.message = Faker::Lorem.sentence
  end
end