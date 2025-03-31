class NativeObject < ApplicationRecord
    validates :company, :car_model, :date_of_sale, :price, presence: true
end
