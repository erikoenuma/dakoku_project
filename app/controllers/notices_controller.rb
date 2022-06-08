class NoticesController < ApplicationController
  before_action :set_notice, only: [:edit, :update]

  # GET /notices/1/edit
  def edit
    @project = @user_project.project
    @user = @user_project.user
    @company = @project.company
  end

  # PATCH/PUT /notices/1
  def update
    @user = @user_project.user
    @project = @user_project.project
    @company = @project.company

    if @notice.update(notice_params)
      flash[:success] = t('.success')
      redirect_to company_member_path(@company, @project, @user)
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notice
      @user_project = UserProject.find(params[:user_project_id])
      @notice = @user_project.notice
    end

    # Only allow a trusted parameter "white list" through.
    def notice_params
      params.require(:notice).permit(:user_project_id, :contents)
    end
end
