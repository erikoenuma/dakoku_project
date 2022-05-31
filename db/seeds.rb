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
user.user_company.authority = Authority.create

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

[
    ['AWAKE', 'awake@example.com', 'awake担当'],
    ['新規勤怠管理アプリ開発', 'kintai@example.com', '田中', '1000', '2023年4月リリース予定', 1],
    ['プロジェクトX', 'projectx@example.com', '山崎', '300', '5/31アップデート予定', 1],
    ['〇×メディア', 'media@example.com', '山田', '200', '10月末までに1000記事', 1]
].each do |name, email, manager, budget, schedule, company_id|
    Project.create(
        {name: name, billing_destination_email: email, billing_destination_manager: manager, budget: budget, schedule: schedule, company_id: company_id}
    )
end

[
    [custom_user.id, 1],
    [custom_user.id, 2],
    [user.id, 2],
    [group_admin.id, 2],
    [admin.id, 3]
].each do |user_id, project_id|
    UserProject.create(
        {user_id: user_id, project_id: project_id}
    )
end

[
    [1, '30', '月', 160, Time.now, nil, false, 'フロントエンドエンジニア', true],
    [2, '40', '月', 80, Time.now, Time.now, true, 'フロントエンドエンジニア', true],
    [3, nil, nil, 160, Time.now, nil, false, 'バックエンドエンジニア', true],
    [4, nil, nil, 160, Time.now, nil, false, 'マネージャー', true],
    [5, nil, nil, 160, Time.now, nil, false, '人事', false]
].each do |user_project_id, wage, wage_per, hours_per_month, start_at, end_at, daily_reports_required, role, under_contract|
    Contract.create(
        {user_project_id: user_project_id,
        wage: wage,
        wage_per:wage_per,
        hours_per_month: hours_per_month,
        start_at: start_at,
        end_at: end_at,
        daily_reports_required: daily_reports_required,
        role: role,
        under_contract: under_contract}
    )
end
