require "application_system_test_case"

class MembersTest < ApplicationSystemTestCase
  setup do
    @member = members(:one)
  end

  test "visiting the index" do
    visit members_url
    assert_selector "h1", text: "Leaderboard"
  end

  test "creating a Member" do
    visit members_url
    click_on "Add Member"

    select_date @member.birthday, from: "member_birthday"
    fill_in "Email address", with: @member.email_address
    fill_in "Name", with: @member.name
    fill_in "Surname", with: @member.surname
    click_on "Create Member"

    assert_text "Member was successfully created"
    click_on "Back"
  end

  test "updating a Member" do
    visit members_url
    click_on "Edit", match: :first

    select_date @member.birthday, from: "member_birthday"
    fill_in "Email address", with: @member.email_address
    fill_in "Name", with: @member.name
    fill_in "Surname", with: @member.surname
    click_on "Update Member"

    assert_text "Member was successfully updated"
    click_on "Back"
  end

  test "destroying a Member" do
    visit members_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Member was successfully destroyed"
  end

  # Source: https://stackoverflow.com/a/27244201
  def select_date(date, options = {})
    field = options[:from]
    select date.strftime('%Y'),  :from => "#{field}_1i"
    select date.strftime('%B'),  :from => "#{field}_2i"
    select date.strftime('%-d'), :from => "#{field}_3i"
  end

end