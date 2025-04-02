require "csv"
require "json"

module NativeObjectsHelper
    def self.load_native_objects_data_from_json(file_path)
        data = JSON.parse(File.read(file_path))

        # data is now an array of hashes. Each hash has string keys.
        data.each do |record|
            native_object = NativeObject.new(
                company: record["company"],
                car_model: record["car_model"],
                date_of_sale: record["date_of_sale"],
                price: record["price"],
                salesperson: record["salesperson"]
            )

            native_object.save
            # Check if the object was saved successfully
            if native_object.persisted?
                # Log the saved object
                Rails.logger.info("Saved: #{native_object.company}, #{native_object.car_model}, #{native_object.date_of_sale}, #{native_object.price}, #{native_object.salesperson}")
            else
                # Log the error message
                Rails.logger.error("Failed to save: #{native_object.errors.full_messages.join(", ")}")
                return false
            end
        end

        true
    end

    def self.load_native_objects_data_from_csv(file_path)
        CSV.foreach(file_path, headers: true) do |row|
            native_object = NativeObject.new(
                company: row["company"],
                car_model: row["car_model"],
                date_of_sale: row["date_of_sale"],
                price: row["price"]
            )

            native_object.save
            # Check if the object was saved successfully
            if native_object.persisted?
                # Log the saved object
                Rails.logger.info("Saved: #{native_object.company}, #{native_object.car_model}, #{native_object.date_of_sale}, #{native_object.price}")
            else
                # Log the error message
                Rails.logger.error("Failed to save: #{native_object.errors.full_messages.join(", ")}")
                return false
            end
        end

        true
    end
end
