class AttendanceTracksController < ApplicationController
  before_action :set_attendance_track, only: %i[ show edit update destroy ]

  # GET /attendance_tracks or /attendance_tracks.json
  def index
    @attendance_tracks = AttendanceTrack.all
  end

  # GET /attendance_tracks/1 or /attendance_tracks/1.json
  def show
  end

  # GET /attendance_tracks/new
  def new
    @attendance_track = AttendanceTrack.new
  end

  # GET /attendance_tracks/1/edit
  def edit
  end

  # POST /attendance_tracks or /attendance_tracks.json
  def create
    @attendance_track = AttendanceTrack.new(attendance_track_params)

    respond_to do |format|
      if @attendance_track.save
        format.html { redirect_to attendance_track_url(@attendance_track), notice: "Attendance track was successfully created." }
        format.json { render :show, status: :created, location: @attendance_track }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendance_tracks/1 or /attendance_tracks/1.json
  def update
    respond_to do |format|
      if @attendance_track.update(attendance_track_params)
        format.html { redirect_to attendance_track_url(@attendance_track), notice: "Attendance track was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance_track }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendance_tracks/1 or /attendance_tracks/1.json
  def destroy
    @attendance_track.destroy

    respond_to do |format|
      format.html { redirect_to attendance_tracks_url, notice: "Attendance track was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance_track
      @attendance_track = AttendanceTrack.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_track_params
      params.require(:attendance_track).permit(:start_at, :end_at, :user_project_id)
    end
end
