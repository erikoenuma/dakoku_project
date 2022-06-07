class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :edit, :update, :destroy]

  # GET /daily_reports/1
  def show
    @project = @user_project.project
    @user = @user_project.user
    @company = @project.company
  end

  # GET /daily_reports/1/edit
  def edit
  end

  # PATCH/PUT /daily_reports/1
  def update
    if @daily_report.update(daily_report_params)
      flash[:success] = t('.success')
      redirect_to user_project_attendance_tracks_url(@user_project)
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_daily_report
      @user_project = UserProject.find(params[:user_project_id])
      @daily_report = @user_project.daily_reports.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def daily_report_params
      params.require(:daily_report).permit(:user_project_id, :date, :contents)
    end
end
