require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_controller = ApplicationController.new
    # CSV Source file
    csv_file_path = "data/source_csv.csv"
    @application_controller.add_data_gathering_job({ path: csv_file_path })

    # JSON Source file
    json_file_path = "data/source_json.json"
    @application_controller.add_data_gathering_job({ path: json_file_path })
  end

  teardown do
    @application_controller.delete_all_native_objects
  end

  test "should import 10 records from CSV source" do
    csv_objects = NativeObject.where(company: "CarDealer B")
    assert_equal 10, csv_objects.length
  end

  test "should import 10 records from JSON source" do
    json_objects = NativeObject.where(company: "CarDealer A")
    assert_equal 10, json_objects.length
  end

  test "CSV object attributes are correct" do
    csv_object = NativeObject.find(4)
    assert_equal "CarDealer B", csv_object.company
    assert_equal "Ford Fusion", csv_object.car_model
    assert_equal "2023-04-20", csv_object.date_of_sale
    assert_equal "22000", csv_object.price
    assert_equal "South", csv_object.region
  end

  test "JSON object attributes are correct" do
    json_object = NativeObject.find(9)
    assert_equal "CarDealer A", json_object.company
    assert_equal "Volkswagen Passat", json_object.car_model
    assert_equal "2023-09-30", json_object.date_of_sale
    assert_equal "28000", json_object.price
    # The region value "Grace Yellow" might be a mistake if region is meant for CSV; adjust as needed.
    assert_equal "Grace Yellow", json_object.region
  end
end