# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :validate_admin_sign_in, only: [:create_admin_session]
  before_action :validate_employee_sign_in, only: [:create_employee_session]
  # Documentでcreateに適用されていたので同様に適用する↓
  prepend_before_action :require_no_authentication, only: [:create_admin_session, :create_employee_session]
  prepend_before_action :allow_params_authentication!, only: [:create, :create_admin_session, :create_employee_session]

  # 管理者ログイン
  def create_admin_session
      self.resource = warden.authenticate!(admin_auth_options)
      sign_in(resource_name, resource)
      set_flash_message!(:success, :signed_in)
      respond_with @user, location: after_sign_in_path_for(@user)
  end

  # 従業者ログイン
  def create_employee_session
    self.resource = warden.authenticate!(employee_auth_options)
    sign_in(resource_name, resource)
    set_flash_message!(:success, :signed_in)
    respond_with @user, location: after_sign_in_path_for(@user)
 
  end

  def employee_login
    @user = User.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end

  def admin_login
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
  
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    @user = User.where(email:params[:user][:email]).first
    if @user.nil?
      flash[:danger] = "メールアドレスが間違っています"
      redirect_to new_user_session_path
      return
    end

    if belongs_to_company
      flash[:success] = "このアカウントは企業に管理されています。従業者ログインからログインしてください。"
      redirect_to new_user_session_path
      return
    else 
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:success, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # 管理者ログイン用バリデーション
  def validate_admin_sign_in
    @user = User.where(email:params[:user][:email]).first
    if @user.nil?
      flash[:danger] = "メールアドレスが間違っています"
      redirect_to companies_admin_login_path
      return
    
    elsif @user.company.nil?
      flash[:danger] = "従業者ではありません。こちらからログインしてください"
      redirect_to new_user_session_path
      return

    elsif @user.company != Company.find(params[:company_id])
      flash[:danger] = "企業IDが違います"
      redirect_to companies_admin_login_path
      return
    
    elsif !isAdmin
      flash[:danger] = "管理者権限がありません"
      redirect_to companies_employee_login_path
    end

  end


  # 従業者ログイン用バリデーション
  def validate_employee_sign_in
    @user = User.where(email:params[:user][:email]).first
    if @user.nil?
      flash[:danger] = "メールアドレスが間違っています"
      redirect_to companies_employee_login_path
      return
    
    elsif @user.company.nil?
      flash[:danger] = "従業者ではありません。こちらからログインしてください"
      redirect_to new_user_session_path
      return

    elsif @user.company != Company.find(params[:company_id])
      flash[:danger] = "企業IDが違います"
      redirect_to companies_employee_login_path
      return
    
    # 案件にまだアサインされていないときはログインしない
    elsif @user.user_projects.empty?
      flash[:danger] = "案件にアサインされてから再度ログインしてください"
      redirect_to companies_employee_login_path
      return
    end
  end

  # ログイン失敗時のリダイレクト先（管理者ログイン）
  def admin_auth_options
    { scope: resource_name, recall: "#{controller_path}#admin_login" }
  end

  # ログイン失敗時のリダイレクト先（従業者ログイン）
  def employee_auth_options
    { scope: resource_name, recall: "#{controller_path}#employee_login" }
  end


  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    @company = current_user.company

    # まだ案件がひとつも無い場合
    if current_user.user_projects.empty?
      
      # 個人アカウントの場合
      if current_user.company.nil?
        user_custom_projects_path(current_user)
      else      
        # 企業アカウントの場合
        case current_user.user_company.authority.authority
        when "group_admin" then
          company_projects_path(@company)
        when "admin" then
          companies_users_path(@company)
        end
      end
    
    else

      # 打刻画面を表示
      @user_project = current_user.user_projects.first
      return top_user_project_attendance_tracks_path(@user_project)

    end
  end

  private

  # ある会社の管理者かどうか
  def isAdmin
    @user = User.where(email:params[:user][:email]).first
    company_id = params[:company_id]
    @user_company = UserCompany.where(company_id: company_id, user_id:@user.id).first
    return Company.find(company_id).users.include?(@user) && @user_company.authority.authority != "employee"
  end

  # 従業者かどうか
  def belongs_to_company
    @user = User.where(email:params[:user][:email]).first
    return !(@user.user_company.nil?)
  end

end
