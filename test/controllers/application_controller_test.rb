require "test_helper"
require "date"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application_controller = ApplicationController.new
    # Add a job for CSV data
    csv_file_path = "data/source_csv.csv"
    @application_controller.add_data_gathering_job({ path: csv_file_path })

    # Add a job for JSON data
    json_file_path = "data/source_json.json"
    @application_controller.add_data_gathering_job({ path: json_file_path })

    # Start a background thread to process jobs until the queue is empty.
    size = 0
    while size < 2 do
      # Break out of the loop when the queue is empty.
      break if ApplicationHelper::QueueProcessor.instance.is_queue_empty?
      begin
        ApplicationHelper::QueueProcessor.instance.process_next_in_queue
      rescue => e
        Rails.logger.error("Error processing job: #{e.message}")
        sleep 1
      end

      size += 1
    end
  end

  teardown do
    # Wait for the polling thread to finish processing all jobs.
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
    assert_equal "2023-04-20", csv_object.date_of_sale.to_s
    assert_equal 22000.0, csv_object.price
  end

  test "JSON object attributes are correct" do
    json_object = NativeObject.find(19)
    assert_equal "CarDealer A", json_object.company
    assert_equal "Volkswagen Passat", json_object.car_model
    assert_equal "2023-09-30", json_object.date_of_sale.to_s
    assert_equal 28000.0, json_object.price
    assert_equal "Grace Yellow", json_object.salesperson
  end

  def parse_date(date_string)
    date_object = Date.parse(date_string)
    date_object.strftime("%a, %d %b %Y")
  end
end
