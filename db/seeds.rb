# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Member.create([
  {current_rank: 1, name: "Bronwyn", surname: "Miller", games_played: 5},
  {current_rank: 2, name: "Jonno", birthday: "2008-07-24", games_played: 2},
  {current_rank: 3, name: "Connor", email_address: "connor@starjuice.net", birthday: "2006-03-29", games_played: 1},
  {current_rank: 4, name: "Johan", surname: "van Dyk", email_address: "johan.van.dyk@example.com", games_played: 2},
  {current_rank: 5, name: "Wynand", surname: "van Dyk", email_address: "wynand@example.com", games_played: 2},
  {current_rank: 6, name: "Sheldon", surname: "Hearn", email_address: "sheldonh@starjuice.net", birthday: "1974-10-18"},
])