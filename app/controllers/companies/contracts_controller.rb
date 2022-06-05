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

    # 既にアサインされている場合を除く
    @user_project = UserProject.find_or_create_by(project_id: params[:id], user_id: params[:user_id])
    if @user_project.contract != nil 
      flash[:danger] = "そのユーザーは既にアサインされています"
      redirect_to new_assign_employee_company_contracts_path(@company, @project)
      return
    end

    @contract = @user_project.build_contract(contract_params)

    respond_to do |format|
      if @contract.save
        flash[:success] = t('.create.success')
        format.html { redirect_to company_project_url(@company, @project) }
      else
        # アサイン失敗した場合user_projectも削除する
        @user_project.destroy
        format.html { render :new_assign_employee }
      end  
    end  
  end

  # 従業員以外をアサインする
  def create_not_employee_assignment
    @company = Company.find(params[:company_id])
    @project = @company.projects.find(params[:id])
    @user = User.where(email: params[:contract][:email]).first

    if @user.nil?
      flash[:danger] = "そのユーザーは存在しません。メールアドレスを確認してください。"
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project)
      return
    elsif @user.company_user
      flash[:danger] = "そのユーザーは企業に属しているためアサインできません"
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project)
      return
    end 

    @user_project = UserProject.find_or_create_by(project_id: params[:id], user_id: @user.id)
    
    if @user_project.contract != nil
      flash[:danger] = "そのユーザーは既にアサインされています"
      redirect_to new_assign_not_employee_company_contracts_path(@company, @project)
      return
    end

    @contract = @user_project.build_contract(contract_params)

    respond_to do |format|
      if @contract.save
        flash[:success] = t('.create.success')
        format.html { redirect_to company_project_url(@company, @project) }
      else
        # アサイン失敗した場合user_projectも削除する
        @user_project.destroy
        format.html { render :new_assign_not_employee }
      end  
    end

  end

  # PATCH/PUT /contracts/1
  def update
    if @contract.update(contract_params)
      flash[:success] = t('.success')
      redirect_to @contract
    else
      flash[:danger] = t('.failure')
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
