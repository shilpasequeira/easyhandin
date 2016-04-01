class SubmissionsController < ApplicationController
  before_action :check_user_is_instructor
  before_action :set_submission, only: [:update, :destroy]

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
        format.html { redirect_to assignment_path(@submission.assignment), notice: 'Submission was successfully updated.' }
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
