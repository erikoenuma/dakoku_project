class Companies::ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    @company = Company.find(params[:company_id])
    @projects = @company.projects.all
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @company = Company.find(params[:company_id])
    @project = @company.projects.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @company = Company.find(params[:company_id])
    @project = @company.projects.create(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to company_project_url(@company, @project), notice: "Project was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to company_project_url(@company, @project), notice: "Project was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to company_projects_url(@company), notice: "Project was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @company = Company.find(params[:company_id])
      @project = @company.projects.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:name, :billing_destination_email, :billing_destination_manager, :budget, :schedule)
    end
end
