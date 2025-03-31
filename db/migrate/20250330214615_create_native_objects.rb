class CreateNativeObjects < ActiveRecord::Migration[8.0]
    def change
        create_table :native_objects do |t|
            t.string :company
            t.string :car_model, :price, :salesperson
            t.date :date_of_sale
            t.float :price
            t.string :salesperson

            t.timestamps
        end
    end
end