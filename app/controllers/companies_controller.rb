class CompaniesController < ApplicationController
    before_action :set_company, only: [:users]

    def users
        @users = @company.users.all
    end

    # 従業員をアサインする
    def assign_employee
        @project = @company.projects.find(params[:project_id])
        
    end

    private

    def set_company
        @company = Company.find(params[:id])
    end

end
