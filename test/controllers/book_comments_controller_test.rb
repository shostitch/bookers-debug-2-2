require "test_helper"

class BookCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get book_comments_show_url
    assert_response :success
  end
end
