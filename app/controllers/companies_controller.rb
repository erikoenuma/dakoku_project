class CompaniesController < Devise::SessionsController
    before_action :set_company, only: [:users]

    def users
        @users = @company.users.all
    end

    def employee_login
        new
    end

    def admin_login
        new
    end

    private

    def set_company
        @company = Company.find(params[:id])
    end

end
