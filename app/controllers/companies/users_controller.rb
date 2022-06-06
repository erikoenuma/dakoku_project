class Companies::UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_q, only: [:show]
    authorize_resource


    def show
        @projects = @user.projects
        @company = Company.find(params[:company_id])
        @project = @company.projects.find(params[:id])
        @user_project = @user.user_projects.where(project_id: params[:id]).first
        @attendance_tracks = @user_project.attendance_tracks
        
        # 実績を月ごとに表示する
        if params[:q].nil?
            # 初期値は現在月
            @results = @attendance_tracks.where('start_at > ?', Time.current.beginning_of_month)
            @date = Time.current
        else
            puts params[:q]
            @results = @q.result
            # 何月を表示しているか
            @date = Time.parse(params[:q][:start_at_gteq])
            puts "何月か", @date.year, @date.month, @date
        end

        # 総勤務時間を計算する
        # 企業の案件に絞る
        @user.projects.where(company_id: params[:company_id]).each do |project|
            # 企業の案件の中でユーザーがアサインされている案件
            @user_projects = @user.user_projects.where(project_id: project.id)
            total_minutes = 0
            @user_projects.each do |t|
                # 勤務時間を足していく
                if t.attendance_tracks.group_by{|p| p.start_at_ja.month }[Time.current.month].nil?
                    return
                else
                    total_minutes += t.attendance_tracks.group_by{|p| p.start_at_ja.month }[Time.current.month].map{|p| p.duration_minutes }.sum
                end
            end
            @monthly_working_time = "今月の総勤務時間：#{(total_minutes/60/60).round}時間#{(total_minutes/60%60).round}分"
        end
    end

    def destroy
        @company = Company.find(params[:company_id])
        @user = User.find(params[:member])
        @project = Project.find(params[:id])
        @user_project = @user.user_projects.where(project_id: params[:id]).first

        @user_project.destroy
        respond_to do |format|
            flash[:success] = "メンバーを案件から除外しました"
            format.html { redirect_to company_project_url(@company, @project) }
        end
    end

    private

    def set_q
        @user = User.find(params[:member])
        @user_project = @user.user_projects.where(project_id: params[:id]).first
        @q = @user_project.attendance_tracks.ransack(params[:q])
    end

end
