# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create, :create_admin_session, :create_employee_session]
  before_action :sign_in_params, only: [:create_admin_session, :create_employee_session]

  # 管理者ログイン
  def create_admin_session
    if isAdmin
      sign_in(@user, scope: :user)
      set_flash_message!(:notice, :signed_in)
      respond_with @user, location: companies_users_url(params[:user][:company_ids])
    else
      redirect_to companies_employee_login_path, alert: "管理者権限がありません"
    end 
  end

  # 従業者ログイン
  def create_employee_session
      if isEmployee
        sign_in(@user, scope: :user)
        set_flash_message!(:notice, :signed_in)
        respond_with @user, location: after_sign_in_path_for(@user)
      else
        puts "従業員じゃない'"
        redirect_to companies_employee_login_path, alert: "企業IDが間違っています"
      end 
 
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
    if belongs_to_company
      flash[:notice] = "このアカウントは企業に管理されています。従業者ログインからログインしてください。"
      redirect_to new_user_session_path
      p "returnするぞ"
      return
    else 
      p "呼ばれとる"
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  def sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:company_ids])
  end

  private

  # ある会社の従業者かどうか
  def isEmployee
    # emailはuniqueなので一つしか返ってこない
    @user = User.where(email:params[:user][:email]).first
    # formに入力されたcompany_idを取得
    company_id = params[:user][:company_ids]
    return Company.find(company_id).users.include?(@user)
  end

  # ある会社の管理者かどうか
  def isAdmin
    @user = User.where(email:params[:user][:email]).first
    company_id = params[:user][:company_ids]
    @user_company = UserCompany.where(company_id:company_id, user_id:@user.id).first
    return Company.find(company_id).users.include?(@user) && @user_company.authority.authority != "employee"
  end

  # 従業者かどうか
  def belongs_to_company
    @user = User.where(email:params[:user][:email]).first
    return !(@user.user_companies.empty?)
  end

end
