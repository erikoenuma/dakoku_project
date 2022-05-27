# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  # 従業員追加画面
  def new_employee
    @company = Company.find(params[:id])
    @user = @company.users.new
    respond_with resource
  end

  # 従業員追加
  def create_employee
    generated_password = Devise.friendly_token.first(8)
    @company = Company.find(params[:id])
    # パスワードを自動作成
    @user = @company.users.create!(:name => params[:user][:name], :email => params[:user][:email], :password => generated_password)
    # 権限作成
    @company.user_companies.where(user_id: @user.id).first.authority = Authority.new
    # パスワードをメールで送信する
    RegistrationMailer.welcome(@user, generated_password).deliver
  end

  # 従業員削除
  def destroy_employee
    @company = Company.find(params[:company_id])
    @user = @company.users.find(params[:id])
    @user.destroy
    set_flash_message! :notice, :employee_destroyed
    respond_with_navigational(resource){ redirect_to companies_users_url(@company) }
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

end
