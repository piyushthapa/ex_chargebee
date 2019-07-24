defmodule ChargeBee.PlanTest do
  use ExUnit.Case
  doctest ChargeBee

  @valid_plan %{id: ChargeBee.Utils.random_string(16), name: ChargeBee.Utils.random_string(16), invoice_name: "test_plan_new", price: "1000"}

  alias ChargeBee.Plan

  setup %{} do
    sample_plan = %{id: ChargeBee.Utils.random_string(16), name: ChargeBee.Utils.random_string(16), invoice_name: "test_plan_sample", price: "5000"}
    { :ok, %{"http_status_code" => 200, "plan" => plan}} = Plan.create(sample_plan)
    {:ok, sample_plan: plan}
  end

  describe "plans tests" do

    test "create/1 with valid params creates new plan" do
      assert { :ok, %{"http_status_code" => 200, "plan" => plan}} = Plan.create(@valid_plan)
      assert is_map(plan)
      assert plan["id"] == @valid_plan.id
      assert {:ok, deleted_plan} = Plan.delete(@valid_plan.id)
    end

    test "list/1 with valid params gives lists of plans", %{sample_plan: _sample_plan} do
      assert { :ok, %{"http_status_code" => 200, "list" => plans}} = Plan.list()
      assert is_list(plans)
      assert hd(plans) |> is_map()
    end

    test "create/2 with invalid params gives error" do
      assert {:error, %{reason: "invalid plan parameters"}} = Plan.create(nil)
      assert {:error, plan_error} = Plan.create(%{})
      assert plan_error["http_status_code"] != 200
    end

    test "retrieve/1 with valid plan_id gives plan info", %{sample_plan: sample_plan} do
      assert { :ok, %{"http_status_code" => 200, "plan" => plan}} = Plan.retrieve(sample_plan["id"])
      assert plan["id"] == sample_plan["id"]
      assert plan == sample_plan
    end

    test "retrieve/1 with invalid plan_id gives error" do
      assert {:error, %{reason: "invalid plan_id"}} = Plan.retrieve(nil)
      assert {:error, plan_retrieve_error} = Plan.retrieve("invalid-plan-id")
      assert plan_retrieve_error["http_status_code"] == 404
    end

    test "delete/1 with valid plan is removed" , %{sample_plan: sample_plan} do
      assert {:ok, %{"http_status_code" => 200, "plan" => deleted_plan}} = Plan.delete(sample_plan["id"])
      assert deleted_plan["id"] == sample_plan["id"]
      assert deleted_plan["status"] == "deleted"
    end

    test "delete/1 with invalid plan_id gives error" do
      assert {:error, %{reason: "invalid plan_id"}} = Plan.delete(nil)
      assert {:error, plan_delete_error} = Plan.delete("invalid-plan-id")
      assert plan_delete_error["http_status_code"] == 404
    end

  end
end
