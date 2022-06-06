class AttendanceTracksController < ApplicationController
  before_action :set_attendance_track, only: [:destroy, :register_end_at, :edit, :update]
  before_action :authenticate_user!
  before_action :set_q, only: [:index, :search]
  authorize_resource

  # GET /attendance_tracks
  def index
    @attendance_tracks = @user_project.attendance_tracks.all
    @user_projects = current_user.user_projects.all
    if params[:q].nil?
      # 初期値は現在月
      @results = @attendance_tracks.where('start_at > ?', Time.current.beginning_of_month)
      @date = Time.current
    else
      @results = @q.result
      # 何月を表示しているか
      @date = Time.parse(params[:q][:start_at_gteq])
    end
    
  end

  def search
    @results = @q.result
    @date = Time.parse(params[:q][:start_at_gteq])
  end

  def new
    @user_project = UserProject.find(params[:user_project_id])
    @attendance_track = @user_project.attendance_tracks.new
  end

  def create
    @user_project = UserProject.find(params[:user_project_id])
    @attendance_track = @user_project.attendance_tracks.create(attendance_track_params)

    respond_to do |format|
      if @attendance_track.save
        flash[:success] = t('.success')
        format.html { redirect_to search_user_project_attendance_tracks_url(@user_project) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end

  def update
    # 時間のみ変更する
    new_start_time = Time.parse(params[:attendance_track][:start_at])
    new_end_time = Time.parse(params[:attendance_track][:end_at])

    new_start_date = @attendance_track.start_at.change(hour: new_start_time.hour, min: new_start_time.min)
    new_end_date = @attendance_track.end_at.change(hour: new_end_time.hour, min: new_end_time.min)

    respond_to do |format|
      if @attendance_track.update(start_at: new_start_date, end_at: new_end_date)
        flash[:success] = t('.success')
        format.html { redirect_to user_project_attendance_tracks_url(@user_project) }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendance_tracks/1
  def destroy
    @attendance_track.destroy

    respond_to do |format|
      flash[:success] = t('.success')
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def top 
    @user_project = UserProject.find(params[:user_project_id])
    @user_projects = current_user.user_projects
    recentTrack = @user_project.attendance_tracks.last
    if recentTrack.nil? || recentTrack.end_at != nil
      @attendance_track = @user_project.attendance_tracks.new
    else
      @attendance_track = recentTrack
    end
  end

  # 開始時刻を記録する
  def register_start_at
    @user_project = UserProject.find(params[:user_project_id])
    @user_projects = current_user.user_projects
    # タイムゾーンを日本にしたいのでTime.currentを使用
    # to_s(:db)を付けてUTCにして、DBに入る形と同じにしている　秒は保存しない
    time = Time.local(Time.current.year, Time.current.month, Time.current.day, Time.current.hour, Time.current.min)
    @attendance_track = @user_project.attendance_tracks.new(start_at: time.to_s(:db))

    respond_to do |format|
      if @attendance_track.save
        flash[:success] = t('.success')
        format.html { redirect_to top_user_project_attendance_tracks_url }
      else
        flash[:danger] = t('.failure')
        format.html { render :top, status: :unprocessable_entity }
      end
    end
  end

  # 終了時刻を記録する
  def register_end_at
    respond_to do |format|
      time = Time.local(Time.current.year, Time.current.month, Time.current.day, Time.current.hour, Time.current.min)
      if @attendance_track.update(end_at: time.to_s(:db))
        flash[:success] = t('.success')
        format.html { redirect_to top_user_project_attendance_tracks_url}
      else
        flash[:danger] = t('.failure')
        format.html { render :top, status: :unprocessable_entity}
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance_track
      @user_project = UserProject.find(params[:user_project_id])
      @attendance_track = @user_project.attendance_tracks.find(params[:id])
    end

    def set_q
      @user_project = UserProject.find(params[:user_project_id])
      @q = @user_project.attendance_tracks.ransack(params[:q])
    end

    def attendance_track_params
      params.require(:attendance_track).permit(:start_at, :end_at)
    end

end
