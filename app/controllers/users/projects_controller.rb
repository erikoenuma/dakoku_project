class Users::ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  load_and_authorize_resource :class => Project


  # GET /projects or /projects.json
  # サインイン後ここにアクセス（projectsが一つでもあれば打刻画面に飛ばす）
  def index
    @projects = current_user.projects.all
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = current_user.projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = current_user.projects.create(project_params)

    respond_to do |format|
      if @project.save
        flash[:success] = t('.success')
        format.html { redirect_to user_custom_projects_path(current_user)  }
      else
        flash[:danger] = t('.failure')
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        flash[:success] = t('.success')
        format.html { redirect_to user_custom_projects_path(current_user) }
      else
        flash[:danger] = t('.failure')
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      flash[:success] = t('.success')
      format.html { redirect_to user_custom_projects_path(current_user) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = current_user.projects.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :billing_destination_email, :billing_destination_manager)
    end
end
