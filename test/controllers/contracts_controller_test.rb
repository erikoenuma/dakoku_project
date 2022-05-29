require 'test_helper'

class ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contract = contracts(:one)
  end

  test "should get index" do
    get contracts_url
    assert_response :success
  end

  test "should get new" do
    get new_contract_url
    assert_response :success
  end

  test "should create contract" do
    assert_difference('Contract.count') do
      post contracts_url, params: { contract: { daily_reports_required: @contract.daily_reports_required, end_at: @contract.end_at, hours_per_month: @contract.hours_per_month, role: @contract.role, start_at: @contract.start_at, under_contract: @contract.under_contract, user_project_id: @contract.user_project_id, wage: @contract.wage, wage_per: @contract.wage_per } }
    end

    assert_redirected_to contract_url(Contract.last)
  end

  test "should show contract" do
    get contract_url(@contract)
    assert_response :success
  end

  test "should get edit" do
    get edit_contract_url(@contract)
    assert_response :success
  end

  test "should update contract" do
    patch contract_url(@contract), params: { contract: { daily_reports_required: @contract.daily_reports_required, end_at: @contract.end_at, hours_per_month: @contract.hours_per_month, role: @contract.role, start_at: @contract.start_at, under_contract: @contract.under_contract, user_project_id: @contract.user_project_id, wage: @contract.wage, wage_per: @contract.wage_per } }
    assert_redirected_to contract_url(@contract)
  end

  test "should destroy contract" do
    assert_difference('Contract.count', -1) do
      delete contract_url(@contract)
    end

    assert_redirected_to contracts_url
  end
end
