class Job < ApplicationRecord
    validates :source, :source_file, :status, presence: true
end