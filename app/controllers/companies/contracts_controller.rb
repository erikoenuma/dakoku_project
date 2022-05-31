class Companies::ContractsController < ApplicationController
  before_action :set_new_contract, only: [:new_assign_employee, :new_assign_not_employee]
  before_action :authenticate_user!
  authorize_resource

  # 従業員アサイン画面
  def new_assign_employee
  end

  # 従業員以外アサイン画面
  def new_assign_not_employee
  end

  # GET /contracts/1/edit
  def edit
  end

  # 従業員をアサインする
  def create_employee_assignment
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])

    if @project.user_ids.include?(Integer(params[:contract][:user]))
      flash[:alert] = "そのユーザーは既にアサインされています"
      redirect_to new_assign_employee_company_contracts_path(@company, @project)
      return
    end
    @user_project = UserProject.find_or_create_by(project_id: params[:id], user_id: params[:contract][:user])
    @contract = Contract.create(contract_params)
    @user_project.contract = @contract
    puts @contract

    respond_to do |format|
      if @contract.save
        format.html { redirect_to company_project_url(@company, @project), notice: t('.create.success') }
      else
        format.html { redirect_to new_assign_employee_company_contracts_path(@company, @project), status: :unprocessable_entity }
      end  
    end  
  end

  # 従業員以外をアサインする
  def create_not_employee_assignment
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    @user = User.where(email: params[:contract][:email]).first
    if @user.nil?
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project), alert: "そのユーザーは存在しません。メールアドレスを確認してください。"
    elsif @user.company_user
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project), alert: "企業に属しているためアサインできません"
    elsif @project.users.include?(@user)
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project), alert: "そのユーザーは既にアサインされています"
    else 

      @user_project = UserProject.find_or_create_by(project_id: params[:id], user_id: @user.id)
      @contract = Contract.create(contract_params)
      @user_project.contract = @contract

      respond_to do |format|
        if @contract.save
          format.html { redirect_to company_project_url(@company, @project), notice: t('.create.success') }
        else
          format.html { redirect_to new_assign_not_employee_company_contracts_path(@company, @project), status: :unprocessable_entity }
        end  
      end    
    end
  end

  # PATCH/PUT /contracts/1
  def update
    if @contract.update(contract_params)
      redirect_to @contract, notice: 'Contract was successfully updated.'
    else
      render :edit
    end
  end

  private

    def set_new_contract
      @company = Company.find(params[:company_id])
      @project = @company.projects.find(params[:id])
      @contract = @project.contracts.new
    end

    # Only allow a trusted parameter "white list" through.
    def contract_params
      params.require(:contract).permit(:wage, :wage_per, :hours_per_month, :start_at, :end_at, :daily_reports_required, :role, :under_contract)
    end
end
