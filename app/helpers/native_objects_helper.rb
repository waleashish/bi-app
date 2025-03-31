require 'csv'
require 'json'

module NativeObjectsHelper < ApplicationHelper
    
    def self.load_native_objects_data_from_json(file_path)
        file_path = "data.json"
        data = JSON.parse(File.read(file_path))

        # data is now an array of hashes. Each hash has string keys.
        data.each do |record|
            native_object = NativeObject.create(
                company:record["company"],
                car_model:record["car_model"],
                date_of_sale:record["date_of_sale"],
                price:record["price"],
                salesperson:record["salesperson"]
            )
        end
    end

    def self.load_native_objects_data_from_csv(file_path)
        CSV.foreach(file_path, headers: true) do |row|
            native_object = NativeObject.create(
                company:row["company"],
                car_model:row["car_model"],
                date_of_sale:row["date_of_sale"],
                price:row["price"],
                salesperson:row["salesperson"]
            )
        end
    end
end