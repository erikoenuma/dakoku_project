class Companies::UsersController < ApplicationController
    before_action :authenticate_user!
    load_and_authorize_resource :class => User


    def show
        @user = User.find(params[:member])
        @projects = @user.projects
        @company = Company.find(params[:company_id])
        @project = @company.projects.find(params[:id])
        @user_project = @user.user_projects.where(project_id: params[:id]).first
        @attendance_tracks = @user_project.attendance_tracks
        @monthly_tracks = @attendance_tracks.group_by{|p| p.start_at_ja.month }
        @user.projects.where(company_id: params[:company_id]).each do |project|
            @user_projects = @user.user_projects.where(project_id: project.id)
            total_minutes = 0
            @user_projects.each do |t|
                if t.attendance_tracks.group_by{|p| p.start_at_ja.month }[Time.now.month].nil?
                    return
                else
                    total_minutes += t.attendance_tracks.group_by{|p| p.start_at_ja.month }[Time.now.month].map{|p| p.duration_minutes }.sum
                end
            end
            puts total_minutes
            @monthly_working_time = "今月の総勤務時間：#{(total_minutes/60/60).round}時間#{(total_minutes/60%60).round}分"
        end
    end

end
