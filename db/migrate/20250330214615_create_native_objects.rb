class CreateNativeObjects < ActiveRecord::Migration[8.0]
    def change
        create_table :native_objects do |t|
            t.string :company, :car_model, :salesperson
            t.date :date_of_sale
            t.float :price

            t.timestamps
        end
    end
end
