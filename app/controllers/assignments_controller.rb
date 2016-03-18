class AssignmentsController < ApplicationController
  before_action :set_course, only: [:new, :index, :create]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy, :test]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = @course.assignments
  end

  # GET /assignments/1
  # GET /assignments/1.json
  def show
    @assignment.submissions.each do |submission|
        response = TestBuildJobParser.perform(
          submission.bk_test_build_id,
          submission.bk_test_job_id
        )

        if Submission.test_results.keys.to_a.include?(response["status"])
          submission.test_result = response["status"]
        else
          submission.test_result = "error"
        end

        submission.test_output = response["content"]
        submission.save!
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

  def test
    @assignment.submissions.each do |submission|
        response = CreateTestBuild.perform(
          submission.repository,
          @assignment.slug,
          @assignment.course.test_repository,
          message: "Creating build for assignment #{@assignment.course.name} - #{@assignment.name} by #{submission.submitter.name}"
        )

        submission.bk_test_build_id = response["number"]
        submission.bk_test_job_id = response["jobs"][0]["id"]

        submission.save!
    end

    flash[:notice] = "Started test build"
    render :show
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.includes(:submissions).find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :slug, :is_published, :deadline, :grace_period, :is_team_mode, :bk_moss_build_id, :bk_moss_job_id, :moss_output, :course_id)
    end
end
