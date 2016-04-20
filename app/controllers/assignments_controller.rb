class AssignmentsController < ApplicationController
  before_action :check_user_is_instructor, only: [:new, :create, :edit, :update, :destroy, :process_submissions, :publish]
  before_action :set_course, only: [:index, :new, :create, :edit, :update]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :process_submissions,
    :moss_build_submissions, :branch_build_submissions, :publish]
  before_action :check_publish_status, only: [:show]
  before_action :set_submissions, only: [:process_submissions]
  skip_before_action :require_login, only: [:moss_build_submissions, :branch_build_submissions]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = @course.assignments
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @course = @assignment.course

    @assignment.submissions.each do |submission|
      submission.update_test_output
    end

    @assignment.update_moss_output

    add_breadcrumb @course.name.upcase, course_path(@course)
    add_breadcrumb @assignment.name.upcase
  end

  # GET /assignments/new
  def new
    if @course.skeleton_repository.nil?
      flash[:error] = "Skeleton repository must be created before an assignment is created. Publish the course."
      redirect_to course_path(@course)
      return
    else
      @assignment = Assignment.new
    end
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = @course.assignments.new(assignment_params)
    if @assignment.save
      flash[:notice] = "Assignment was successfully created."
      redirect_to @assignment
    else
      flash[:error] = "Assignment could not be created."
      flash[:error_messages] = @assignment.errors.full_messages
      redirect_to @course
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    if @assignment.update(assignment_params)
      flash[:notice] = "Assignment was successfully updated."
      redirect_to action: :show
    else
      flash[:error] = "Assignment could not be updated."
      flash[:error_messages] = @assignment.errors.full_messages
      redirect_to action: :show
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    flash[:notice] = "Assignment was successfully destroyed."
    redirect_to course_path(@assignment.course)
  end

  def process_submissions
    unless @assignment.is_published?
      flash[:error] = "Cannot process submissions when assignment is not published."
      redirect_to action: :show
      return
    end

    begin
      if params[:run_tests]
        @assignment.run_tests(@submissions)
        flash[:notice] = "Started build to run tests."
      elsif params[:run_moss]
        @assignment.run_moss(@submissions)
        flash[:notice] = "Started build to run MOSS."
      end
    rescue => e
      Rails.logger.error {
        "Error when trying to create a process submissions #{e.message} #{e.backtrace.join("\n")}"
      }
      flash[:error] = e.message
    end

    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  def moss_build_submissions
    render json: @assignment.moss_build_submissions
  end

  def branch_build_submissions
    render json: @assignment.branch_build_submissions
  end

  def publish
    if @assignment.is_published?
      flash[:error] = "Assignment is already published."
      redirect_to action: :show
      return
    end

    if @assignment.course.is_published
      begin
        @assignment.publish
        flash[:notice] = "Started build to create assignment branches on submission repositories."
      rescue => e
        Rails.logger.error {
          "Error when trying to publish the assignment #{e.message} #{e.backtrace.join("\n")}"
        }
        flash[:error] = e.message
      end
    else
      flash[:error] = "Course #{@assignment.course.name} must be published first."
    end

    redirect_to action: :show
  end

  private

  def set_assignment
    @assignment = Assignment.includes(:submissions).find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_submissions
    @submissions = Submission.where(id: params[:submission_ids])
  end

  def check_publish_status
    if current_user.instructor? && !@assignment.is_published?
      flash[:warning] = "There are branches yet to be created. Publish the assignment to create them."
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:name, :branch_name, :is_published, :deadline, :grace_period,
      :is_team_mode, :bk_moss_build_id, :bk_moss_job_id, :moss_output, :language, :course_id,
      :skeleton_branch_name)
  end
end
