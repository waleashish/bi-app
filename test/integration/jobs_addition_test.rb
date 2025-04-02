require "test_helper"
require "date"

class JobsAdditionTest < ActionDispatch::IntegrationTest
  test "add 2 jobs" do
    # Add a job for CSV data
    csv_file_path = "data/source_csv.csv"
    post jobs_add_job_url, params: { source: "csv", source_file: csv_file_path, status: "ADDED" }

    # Add a job for JSON data
    json_file_path = "data/source_json.json"
    post "/jobs/add-job", params: { source: "json", source_file: json_file_path, status: "ADDED" }

    # Check if the jobs were added successfully
    assert_equal 2, Job.count
  end

  test "Add and process a job" do
    # Add a job for JSON data
    json_file_path = "data/source_json.json"
    post "/jobs/add-job", params: { source: "json", source_file: json_file_path, status: "ADDED" }

    begin
      ApplicationHelper::QueueProcessor.instance.process_next_in_queue
    rescue => e
      Rails.logger.error("Error processing job: #{e.message}")
    end
    sleep 1

    json_objects = NativeObject.count
    assert_equal 10, json_objects

    json_object = NativeObject.find(9)
    assert_equal "CarDealer A", json_object.company
    assert_equal "Volkswagen Passat", json_object.car_model
    assert_equal "2023-09-30", json_object.date_of_sale.to_s
    assert_equal 28000.0, json_object.price
    assert_equal "Grace Yellow", json_object.salesperson
  end
end
