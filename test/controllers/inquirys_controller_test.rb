require 'test_helper'

class InquirysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get inquirys_index_url
    assert_response :success
  end

  test "should get confirm" do
    get inquirys_confirm_url
    assert_response :success
  end

  test "should get thanks" do
    get inquirys_thanks_url
    assert_response :success
  end
end
