class CreateSprints < ActiveRecord::Migration[6.1]
  def change
    create_table :sprints do |t|
      t.string :name, null: false
      t.date :start_on, null: false
      t.date :end_on, null: false

      t.timestamps
    end
  end
end
