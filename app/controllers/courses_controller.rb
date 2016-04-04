class CoursesController < ApplicationController
  before_action :check_user_is_instructor, only: [:new, :create, :edit, :update, :destroy, :publish, :students, :instructors]
  before_action :set_course, only: [:show, :edit, :update, :destroy, :publish, :students, :instructors]

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
      @course.publish(session[:access_token])
      flash[:notice] = "Course was published successfully!"
    rescue => e
      flash[:error] = "Could not publish course. #{e.message}"
    end

    redirect_to action: :show
  end

  def students
  end

  def instructors
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.includes(:students, :assignments).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :slug, :is_published, :test_repository, :skeleton_repository)
  end
end
