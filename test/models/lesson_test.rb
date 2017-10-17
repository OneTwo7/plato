require 'test_helper'

class LessonTest < ActiveSupport::TestCase

  setup do
    @path = paths(:one)
  end
  
  test "lesson should have a name" do
    lesson = @path.lessons.create({
      name: "",
      content: "content"
    })
    assert_not lesson.valid?
  end

  test "lesson should have content" do
    lesson = @path.lessons.create({
      name: "name",
      content: ""
    })
    assert_not lesson.valid?
  end

  test "lesson should have path id" do
    lesson = Lesson.new({
      name: "name",
      content: "content"
    })
    assert_not lesson.valid?
  end

  test "content with script tags should be invalid" do
    lesson = @path.lessons.create({
      name: "name",
      content: "content\n<script>\nalert('hi!')\n</script>\ncontent"
    })
    assert_not lesson.valid?
  end

  test "content with img tags should be invalid" do
    lesson = @path.lessons.create({
      name: "name",
      content: "content\n<img src='pic.jpg' alt='pic'>\ncontent"
    })
    assert_not lesson.valid?
  end

  test "content with html comments tags should be invalid" do
    lesson = @path.lessons.create({
      name: "name",
      content: "content\n<!-- A comment -->\ncontent"
    })
    assert_not lesson.valid?
  end

end
