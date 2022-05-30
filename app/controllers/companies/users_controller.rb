class Companies::UsersController < ApplicationController
    # before_action :set_month, only: [:show]

    def show
        @user = User.find(params[:member])
        @projects = @user.projects
        @user_project = @user.user_projects.where(project_id: params[:id]).first
        @contract = @user_project.contract
        @attendance_tracks = @user_project.attendance_tracks
        @monthly_tracks = @attendance_tracks.group_by{|p| p.start_at.in_time_zone('Tokyo').month }
    end

    private 

    def set_month
        @attendance_tracks = @user_project.attendance_tracks
        @month_groups = @attendance_tracks.group_by{|p| p.start_at.month }[5]
    end

end
