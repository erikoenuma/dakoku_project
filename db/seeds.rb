# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

custom_user = User.new
custom_user.name = 'testCustomUser'
custom_user.email = 'test@test.com'
custom_user.password = 'password'
custom_user.password_confirmation = 'password'
custom_user.save!

company = Company.create(name: 'Test Company', email: 'testCompany@test.com', zipcode: '0000000', address: 'testAddress', phone_number: '1234567891')
company.save!

user = User.new
user.name = "testEmployee"
user.email = "testEmployee2@test.com"
user.password = "password"
user.password_confirmation = "password"
user.save!
company.users << user

admin = User.new
admin.name = "admin"
admin.email = "admin@test.com"
admin.password = "password"
admin.password_confirmation = "password"
admin.save!
company.users << admin
admin.user_company.authority = Authority.create(authority: "admin")

group_admin = User.new
group_admin.name = "group_admin"
group_admin.email = "group_admin@test.com"
group_admin.password = "password"
group_admin.password_confirmation = "password"
group_admin.save!
company.users << group_admin
group_admin.user_company.authority = Authority.create(authority: "group_admin")