require 'test_helper'

class LessonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @path = paths(:one)
    @lesson = lessons(:one)
  end

  test "should get index" do
    get path_lessons_url(@path)
    assert_response :success
  end

  test "should get new" do
    get new_path_lesson_url(@path)
    assert_response :success
  end

  test "should create lesson" do
    assert_difference('Lesson.count') do
      post path_lessons_url(@path), params: { lesson: { content: @lesson.content, name: @lesson.name } }
    end

    assert_redirected_to @path
  end

  test "should show lesson" do
    get path_lesson_url(@path, @lesson)
    assert_response :success
  end

  test "should get edit" do
    get edit_path_lesson_url(@path, @lesson)
    assert_response :success
  end

  test "should update lesson" do
    patch path_lesson_url(@path, @lesson), params: { lesson: { content: @lesson.content, name: @lesson.name } }
    assert_redirected_to path_lesson_url(@path, @lesson)
  end

  test "should destroy lesson" do
    assert_difference('Lesson.count', -1) do
      delete path_lesson_url(@path, @lesson)
    end

    assert_redirected_to @path
  end
end
