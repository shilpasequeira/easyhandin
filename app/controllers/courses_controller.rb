class CoursesController < ApplicationController
  require 'csv'

  before_action :check_user_is_instructor, only: [:new, :create, :edit, :update, :destroy, :publish, :students, :instructors]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :publish, :students, :instructors, :import_students_csv]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.instructors.push(current_user)
    if @course.save
      flash[:notice] = "Course was successfully created."
      redirect_to @course
    else
      flash[:error] = "Course could not be created."
      @errors = @course.errors
      render 'new'
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    if @course.update(course_params)
      flash[:notice] = "Course was successfully updated."
      redirect_to @course
    else
      flash[:error] = "Course could not be updated."
      @errors = @course.errors
      render 'edit'
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    flash[:notice] = "Course was successfully destroyed."
    redirect_to courses_url
  end

  def publish
    begin
      @course.create_test_skeleton_repos
      @course.create_student_repos
      @course.create_team_repos
      flash[:notice] = "Course was published successfully!"
    rescue => e
      Rails.logger.error {
        "Error when trying to create a publish course #{e.message} #{e.backtrace.join("\n")}"
      }
      flash[:error] = e.message
    end

    redirect_to action: :show
  end

  def students
  end

  def instructors
  end

  def import_students_csv
    csv_file = course_params[:students_csv]

    CSV.foreach(csv_file.path, headers: true) do |row|
      if @invite = Invite.find_by(course_id: @course.id, sender_id: current_user.id, email: row["Email"])
        InviteMailer.existing_user_invite(@invite).deliver_now
      else
        @invite = Invite.new({
          course_id: @course.id,
          user_role: "student",
          name: row["Name"],
          email: row["Email"],
          university_id: row["Student ID"],
          team_number: row["Team"],
          sender_id: current_user.id
        })

        if @invite.save
          if @invite.recipient != nil
            @invite.recipient.complete_invitation(@invite)
            InviteMailer.existing_user_invite(@invite).deliver_now
          else
            InviteMailer.new_user_invite(@invite, signin_link(role: @invite.user_role, invite_token: @invite.token)).deliver_now
          end
        end
      end
    end

    redirect_to action: :students
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.includes(:students, :assignments).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :org_name, :students_csv)
  end
end
