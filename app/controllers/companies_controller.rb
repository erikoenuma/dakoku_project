class CompaniesController < ApplicationController
    before_action :set_company, only: [:users, :assign, :validate_employee]

    def users
        @users = @company.users.all
    end

    def assign 
        @projects = @company.projects.all
        @user_project = UserProject.new
    end

    # 社員アサインと社員以外アサインでリダイレクト先を変える
    def validate_employee 
        @project = @company.projects.find(params[:user_project][:project_id])
        puts params[:user_project][:employee]
        if params[:user_project][:employee] == "true"
            puts "社員"
            redirect_to new_assign_employee_company_contracts_path(@company, @project)
        else
            puts "社員以外"
            redirect_to new_assign_not_employee_company_contracts_path(@company, @project)
        end
    end

    private

    def set_company
        @company = Company.find(params[:id])
    end

    def assign_params
        params.require(:user_project).permit(:project_id, :employee, :email)
    end
end
