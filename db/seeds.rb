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

company = Company.create(
    name: 'Test Company',
    email: 'testCompany@test.com',
    zipcode: '0000000',
    address: 'testAddress',
    phone_number: '1234567891'
)
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

custom_user2 = User.new
custom_user2.name = 'custom2'
custom_user2.email = 'test2@test.com'
custom_user2.password = 'password'
custom_user2.password_confirmation = 'password'
custom_user2.save!

[
    ['AWAKE', 'awake@example.com', 'awake担当'],
    ['新規勤怠管理アプリ開発', 'kintai@example.com', '田中', '1000', '2023年4月リリース予定', 1],
    ['プロジェクトX', 'projectx@example.com', '山崎', '300', '5/31アップデート予定', 1],
    ['〇×メディア', 'media@example.com', '山田', '200', '10月末までに1000記事', 1],
    ['▽マーケティング', 'marketing@example.com', '原口', '400', '当面SEO上げに注力',1]
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
    [admin.id, 3],
    [custom_user2.id, 3]
].each do |user_id, project_id|
    UserProject.create(
        {user_id: user_id, project_id: project_id}
    )
end

[
    [1, '300000', '月', 160, Time.now, nil, false, 'フロントエンドエンジニア', true],
    [2, '400000', '月', 80, Time.now, Time.now, true, 'フロントエンドエンジニア', true],
    [3, nil, nil, 160, Time.now, nil, true, 'バックエンドエンジニア', true],
    [4, nil, nil, 160, Time.now, Time.now + 24*60*60*100, true, 'マネージャー', true],
    [5, nil, nil, 160, Time.now, nil, true, '人事', false],
    [6, '8000', '1時間', 100, Time.now+24*60*60*7, Time.now+24*60*60*365, true, '営業', false]
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

[
    [1, Time.now - 24*60*60*3 , Time.now - 24*60*60*3 + 60*60*5],
    [1, Time.now - 24*60*60*1 , Time.now - 24*60*60*1 + 60*60*8],
    [2, Time.now - 24*60*60 , Time.now - 24*60*60 + 60*60*3],
    [3, Time.now, nil],
    [4, Time.now - 60*60*3 , Time.now + 60*60*3 + 25],
    [5, Time.now - 24*60*60 -1000 , Time.now - 24*60*60 + 60*60*5],
    [5, Time.now, Time.now + 60*60*4 + 60*30]
].each do |user_project_id, start_at, end_at|
    AttendanceTrack.create({
        user_project_id: user_project_id,
        start_at: start_at,
        end_at: end_at
    })
end

[
    ['株式会社〇〇', 'marumaru@company.com', '1233456', '東京都渋谷区桜木町1-1-1', '1234456234'],
    ['株式会社sankaku', 'sankaku@company.com', '1233456', '東京都品川区南品川1-1-1', '123449878'],
    ['yaoya商店', 'yaoya@super.com', '1233456', '東京都港区田町1-1-1', '1234456234'],
    ['山田太郎', 'taroyama@houjin.com', '1233456', '神奈川県川崎市1-1-1', '1234456234']
].each do |name, email, zipcode, address, phone_number|
    Company.create(
        {name: name,
        email: email,
        zipcode: zipcode,
        address: address,
        phone_number: phone_number}
    )
end

10.times do |n|
    user = User.new
    user.name = "#{n}太郎"
    user.email = "#{n}tarou@test.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.save!
    company = Company.find(rand(1...5))
    company.users << user
    user.user_company.authority = Authority.create(authority: rand(0...2))
end

AttendanceTrack.all.each do |track|
    if track.user_project.contract.daily_reports_required
        track.user_project.daily_reports.new(date: track.start_at.to_date).save!
    end
end