class LessonsController < ApplicationController
  before_action :set_path
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = @path.lessons
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = Lesson.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = @path.lessons.create(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to @path, notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
        format.js
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to path_lesson_path(@path, @lesson), notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @id = params[:id]
    @path_id = params[:path_id]
    @first_lesson = @path.lessons.first
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to @path, notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_path
      @path = Path.find(params[:path_id])
    end

    def set_lesson
      @lesson = @path.lessons.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name, :content)
    end
end
