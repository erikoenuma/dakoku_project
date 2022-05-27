class CompaniesController < ApplicationController
    before_action :set_company, only: [:users]

    def users
        @users = @company.users.all
    end

    private

    def set_company
        @company = Company.find(params[:id])
    end

end
