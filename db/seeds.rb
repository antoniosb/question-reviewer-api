# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
QuestionAlternative.destroy_all
Question.destroy_all
User.destroy_all
users = User.create([{
  login: 'normal',
  is_admin: false,
  password: 'abcd@123'
},{
  login: 'admin',
  is_admin: true,
  password: '123@abcd'
}])

questions = Question.create([{
  content: 'Question 1?',
  source: 'UFMG',
  year: 2017,
  user: users.first
},{
  content: 'Question 2?',
  source: 'UFMG',
  year: 2016,
  user: users[1]
}])

questions.each do |question|
  4.times do |i|
    QuestionAlternative.create({
      content: "Options #{i}",
      is_correct: i == 1,
      question: question
    })
  end    
end