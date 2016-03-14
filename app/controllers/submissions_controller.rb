class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    response = TestBuildJobParser.perform(@submission.bk_test_build_id, @submission.bk_test_job_id)

    if Submission.test_results.keys.to_a.include?(response["status"])
      @submission.test_result = response["status"]
    else
      @submission.test_result = "error"
    end

    @submission.test_output = response["output"]
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.save
        format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def test
    @submission = Submission.find(params[:id])
    response = CreateTestBuild.perform(@submission.submitter.course_students.first.student_repository, 
      @submission.assignment.slug, @submission.assignment.course.test_repository, 
      message: "Creating build for assignment #{@submission.assignment.course.name} #{@submission.assignment.name}")

    @submission.bk_test_build_id = response["number"]
    @submission.bk_test_job_id = response["jobs"][0]["id"]

    @submission.save!

    flash[:notice] = "Started test build"
    redirect_to "submissions/show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:submitter_id, :submitter_type, :assignment_id, :grade, :feedback, :test_output, :test_result, :bk_test_build_id, :bk_test_job_id)
    end
end
