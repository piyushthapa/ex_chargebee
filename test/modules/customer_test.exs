defmodule ChargeBee.CustomerTest do
  use ExUnit.Case
  alias ChargeBee.Customer
  alias ChargeBee.Utils

  doctest ChargeBee
  @valid_customer %{
    first_name: "John",
    last_name: "Doe",
    email: "test@email.com",
    billing_address: %{ first_name: "John",  last_name: "Doe",  line1: "PO Box 9999",  city: "Walnut", state: "California", zip: "91789", country: "US"}
  }

  @update_customer %{first_name: "updated_name", last_name: "updated_last_name"}

  setup  do
    assert { :ok, %{"http_status_code" => 200, "customer" => customer}} = Customer.new(@valid_customer)
    {:ok, customer: customer}
  end

  describe "Chargebee Customer test" do
    test "with valid customer info creates new customer" do
      assert { :ok, %{"http_status_code" => 200, "customer" => customer}} = Customer.new(@valid_customer)
      assert customer["first_name"] == @valid_customer.first_name
      assert customer["billing_address"] == Utils.to_string_map(@valid_customer.billing_address)
      assert is_binary(customer["id"])
    end

    test "with list/1 we can list customers", %{customer: _customer} do
      assert { :ok, %{"http_status_code" => 200, "list" => customers}} = Customer.list()
      assert is_list(customers)
      assert hd(customers) |> is_map()
    end

    test "with valid customer_id we can retrieve customer information", %{customer: customer} do
      assert { :ok, %{"http_status_code" => 200, "customer" => retrieved_customer}} = Customer.retrieve(customer["id"])
      assert customer == retrieved_customer
    end

    test "with valid customer_id we can update customer info", %{customer: customer} do
      assert { :ok, %{"http_status_code" => 200, "customer" => updated_customer}} = Customer.update(customer["id"], @update_customer)
      assert updated_customer["id"] == customer["id"]
      assert updated_customer["first_name"] == @update_customer.first_name
      assert updated_customer["last_name"] == @update_customer.last_name
    end


  end
end
