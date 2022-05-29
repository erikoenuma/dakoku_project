class Companies::ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :destroy]
  before_action :set_new_contract, only: [:new_assign_employee, :new_assign_not_employee]

  # GET /contracts
  def index
    @contracts = Contract.all
  end

  # GET /contracts/1
  def show
  end

  # GET /contracts/new
  def new
  end

  # 従業員アサイン画面
  def new_assign_employee
  end

  # 従業員以外アサイン画面
  def new_assign_not_employee
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  def create
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    @project.users << User.find(params[:contract][:user])
    @user_project = UserProject.where(project_id: params[:id], user_id: params[:contract][:user]).first
    @contract = @user_project.contracts.create(contract_params)

    if @contract.save
      redirect_to company_project_path(@company, @project), notice: t('.create.success')
    else
      render :new_assign_employee
    end
  end

  # 従業員をアサインする
  def create_employee_assignment
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    @project.users << User.find(params[:contract][:user])
    @user_project = UserProject.where(project_id: params[:id], user_id: params[:contract][:user]).first
    @contract = @user_project.contracts.create(contract_params)

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
    else 
      @project.users << @user
      @user_project = UserProject.where(project_id: params[:id], user_id: params[:contract][:user]).first
      @contract = @user_project.contracts.create(contract_params)

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

  # DELETE /contracts/1
  def destroy
    @contract.destroy
    redirect_to contracts_url, notice: 'Contract was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    def set_new_contract
      @company = Company.find(params[:company_id])
      @project = @company.projects.find(params[:id])
      @contract = @project.contracts.new
    end

    # Only allow a trusted parameter "white list" through.
    def contract_params
      params.require(:contract).permit(:user_project_id, :wage, :wage_per, :hours_per_month, :start_at, :end_at, :daily_reports_required, :role, :under_contract)
    end
end