class CreateCommitments < ActiveRecord::Migration[6.1]
  def change
    create_table :commitments do |t|
      t.references :quarter, null: false, foreign_key: true

      t.integer :number, null: false
      t.string :name, null: false

      t.text :overview
      t.text :benefits, default: [], array: true
      t.text :actions, default: [], array: true
      t.text :commodities, default: [], array: true

      t.timestamps
    end
  end
end
