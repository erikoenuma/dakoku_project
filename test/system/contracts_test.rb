require "application_system_test_case"

class ContractsTest < ApplicationSystemTestCase
  setup do
    @contract = contracts(:one)
  end

  test "visiting the index" do
    visit contracts_url
    assert_selector "h1", text: "Contracts"
  end

  test "creating a Contract" do
    visit contracts_url
    click_on "New Contract"

    check "Daily reports required" if @contract.daily_reports_required
    fill_in "End at", with: @contract.end_at
    fill_in "Hours per month", with: @contract.hours_per_month
    fill_in "Role", with: @contract.role
    fill_in "Start at", with: @contract.start_at
    check "Under contract" if @contract.under_contract
    fill_in "User project", with: @contract.user_project_id
    fill_in "Wage", with: @contract.wage
    fill_in "Wage per", with: @contract.wage_per
    click_on "Create Contract"

    assert_text "Contract was successfully created"
    click_on "Back"
  end

  test "updating a Contract" do
    visit contracts_url
    click_on "Edit", match: :first

    check "Daily reports required" if @contract.daily_reports_required
    fill_in "End at", with: @contract.end_at
    fill_in "Hours per month", with: @contract.hours_per_month
    fill_in "Role", with: @contract.role
    fill_in "Start at", with: @contract.start_at
    check "Under contract" if @contract.under_contract
    fill_in "User project", with: @contract.user_project_id
    fill_in "Wage", with: @contract.wage
    fill_in "Wage per", with: @contract.wage_per
    click_on "Update Contract"

    assert_text "Contract was successfully updated"
    click_on "Back"
  end

  test "destroying a Contract" do
    visit contracts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Contract was successfully destroyed"
  end
end
