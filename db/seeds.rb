# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if User.find_by(email: 'admin@example.com').nil?
  User.create(name: 'admin', email: 'admin@example.com', password: 'password', password_confirmation: 'password', admin: true)
  User.create(name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password', admin: false)
end
