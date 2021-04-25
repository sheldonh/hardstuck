require "test_helper"

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:one)
  end

  test "should get index" do
    get members_url
    assert_response :success
  end

  test "should get new" do
    get new_member_url
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      # TODO current_rank should be calculated in a before_create
      post members_url, params: { member: { birthday: @member.birthday, current_rank: 3, email_address: @member.email_address, games_played: @member.games_played, name: @member.name, surname: @member.surname } }
    end

    assert_redirected_to member_url(Member.last)
  end

  test "should show member" do
    get member_url(@member)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_url(@member)
    assert_response :success
  end

  test "should update member" do
    patch member_url(@member), params: { member: { birthday: @member.birthday, current_rank: @member.current_rank, email_address: @member.email_address, games_played: @member.games_played, name: @member.name, surname: @member.surname } }
    assert_redirected_to member_url(@member)
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete member_url(@member)
    end

    assert_redirected_to members_url
  end
end
