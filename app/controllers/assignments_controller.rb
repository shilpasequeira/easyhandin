class AssignmentsController < ApplicationController
  before_action :check_user_is_instructor, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_course, only: [:new, :index, :create]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :process_submissions, :submission_repo_sha]
  before_action :set_submissions, only: [:process_submissions]
  skip_before_action :require_login, only: :submission_repo_sha

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = @course.assignments
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @assignment.submissions.each do |submission|
      submission.update_test_output
    end
  end

  # GET /assignments/new
  def new
    @assignment = Assignment.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = @course.assignments.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to @assignment, notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def process_submissions
    if params[:run_tests]
      @assignment.run_tests(@submissions)
      @response = "Started build to run tests."
    elsif params[:run_moss]
      @assignment.run_moss(@submissions)
      @response = "Started build to run MOSS."
    elsif params[:moss_output]
      @assignment.update_moss_output
    end

    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  def submission_repo_sha
    render json: @assignment.submission_repo_sha
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.includes(:submissions).find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_submissions
    @submissions = Submission.where(id: params[:submission_ids])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:name, :slug, :is_published, :deadline, :grace_period, :is_team_mode, :bk_moss_build_id, :bk_moss_job_id, :moss_output, :course_id)
  end
end
