class ContractsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_contract, only: [:show, :edit, :update]

    def show
    end

    def edit
    end

    def update
        if @contract.update(contract_params)
            flash[:success] = t('.success')
            redirect_to user_project_contract_path(@user_project, @contract)
        else
            render :edit
        end
    end

    private
    
    def contract_params
        params.require(:contract).permit(:wage, :wage_per, :hours_per_month, :start_at, :end_at, :daily_reports_required, :role, :under_contract)
    end

    def set_contract
        @user_project = UserProject.find(params[:user_project_id])
        @contract = @user_project.contract
    end


end