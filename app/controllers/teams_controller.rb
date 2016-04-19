class TeamsController < ApplicationController
  before_action :check_user_is_instructor, only: [:create, :update, :destroy]
  before_action :set_course
  before_action :set_team, only: [:update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @teams = @course.teams
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = @course.teams.new(team_params)
    if @team.save
      flash[:notice] = "Team was successfully created."
    else
      flash[:error] = "Team could not be created."
      flash[:error_messages] = @team.errors.full_messages
    end
    redirect_to course_path(@course)
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.update(team_params)
      flash[:notice] = "Team was successfully updated."
    else
      flash[:error] = "Team could not be updated."
      flash[:error_messages] = @team.errors.full_messages
    end
    redirect_to course_path(@course)
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    flash[:notice] = "Team was successfully destroyed."
    redirect_to course_path(@course)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:name, :course_id)
  end
end
