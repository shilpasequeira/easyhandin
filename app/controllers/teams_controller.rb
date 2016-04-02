class TeamsController < ApplicationController
  before_action :check_user_is_instructor, only: [:new, :create, :update, :destroy]
  before_action :set_course
  before_action :set_team

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
      notice = 'Team was successfully created.'
    else
      notice = 'Team @team.name could not be saved.'
    end
    redirect_to(course_path(@course.id), :notice => notice)
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    if @team.update(team_params)
      notice = 'Team was successfully updated.'
    else
      notice = 'Team @team.name could not be updated.'
    end
    redirect_to(course_path(@course), :notice => notice)
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      notice = 'Team was successfully destroyed.'
      format.html { redirect_to course_path(@course), notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
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
    params.require(:team).permit(:name, :slug, :repository, :course_id)
  end
end
