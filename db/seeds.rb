# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

USERS = {name: 'testuser1', email: 'test1@test', password: 'testtest'},
        {name: 'testuser2', email: 'test2@test', password: 'testtest'}

BOOKS = [
  [
    {title: '風の谷のナウシカ', body: '面白かったです'},
    {title: 'ハウルの動く城', body: '考えさせられました'}
  ],
  [
    {title: '崖の上のポニョ', body: '魚の子'},
    {title: '千と千尋の神隠し', body: '働かせてください！'}
  ]
]

USERS.each do |user|
  unless  User.where(email: user[:email]).exists?
    User.create!(user)
  end
end

USERS.size.times do |i|
  BOOKS[i].each do |books|
    User.find(i + 1).books.create(books)
  end
end
