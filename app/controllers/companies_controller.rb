class CompaniesController < ApplicationController
    before_action :set_company, only: [:users, :assign, :validate_employee]
    before_action :authenticate_user!
    authorize_resource
    
    # 従業員一覧画面
    def users
        @users = @company.users.all
    end

    # 新規アサイン画面
    def assign 
        @company = Company.find(params[:id])
        @projects = @company.projects.all
        @user_project = UserProject.new
    end

    # 社員アサインと社員以外アサインでリダイレクト先を変える
    def validate_employee 
        @project = @company.projects.find(params[:project_id])
        if params[:employee] == "true"
            redirect_to new_assign_employee_company_contracts_path(@company, @project)
        else
            redirect_to new_assign_not_employee_company_contracts_path(@company, @project)
        end
    end

    private

    def set_company
        @company = Company.find(params[:id])
    end
end
