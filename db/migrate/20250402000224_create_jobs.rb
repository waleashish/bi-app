class CreateJobs < ActiveRecord::Migration[8.0]
    def change
        create_table :jobs do |t|
            t.string :source, :source_file, :status
            t.timestamps
        end
    end
end
