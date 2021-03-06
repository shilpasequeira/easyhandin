class CoursesController < ApplicationController
  require 'csv'

  before_action :check_user_is_instructor, only: [:create, :update, :destroy, :publish, :students, :instructors, :import_students_csv]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :publish, :students, :instructors, :import_students_csv]
  before_action :check_publish_status, only: [:show]

  # GET /courses
  # GET /courses.json
  def index
    @courses = current_user.courses
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    add_breadcrumb @course.name.upcase
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
      flash[:error_messages] = @course.errors.full_messages
      redirect_to action: :index
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
      flash[:error_messages] = @course.errors.full_messages
      redirect_to action: :index
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    if params[:student_id]
      student = User.find(params[:student_id])
      @course.students.delete(student)
      flash[:notice] = "#{student.name} was removed from the course."
      redirect_to action: :students
    elsif params[:instructor_id]
      instructor = User.find(params[:student_id])
      @course.instructors.delete(instructor)
      flash[:notice] = "#{instructor.name} was removed from the course."
      redirect_to action: :instructors
    else
      @course.destroy
      flash[:notice] = "Course was successfully destroyed."
      redirect_to courses_url
    end
  end

  def publish
    redirect_to action: :show if @course.is_published?

    begin
      @course.create_test_skeleton_repos
      @course.create_student_repos
      @course.create_team_repos
      @course.is_published = true
      @course.save!
      flash[:notice] = "Successfully created the Skeleton, Test, Student and Team repositories!"
    rescue => e
      Rails.logger.error {
        "Error when trying to create a publish course #{e.message} #{e.backtrace.join("\n")}"
      }
      flash[:error] = e.message
    end

    redirect_to action: :show
  end

  def students
    add_breadcrumb @course.name.upcase, course_path(@course)
    add_breadcrumb "STUDENTS"
  end

  def instructors
    add_breadcrumb @course.name.upcase, course_path(@course)
    add_breadcrumb "INSTRUCTORS"
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

  def set_course
    @course = Course.includes(:students, :assignments).find(params[:id])
  end

  def check_publish_status
    if current_user.instructor? && !@course.is_published?
      flash[:warning] = "There are repositories yet to be created. Publish the course to create them."
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :org_name, :students_csv)
  end
end
