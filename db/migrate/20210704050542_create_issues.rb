class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.references :update, null: false, foreign_key: { on_delete: :cascade }
      t.text :description
      t.text :treatment
      t.text :help

      t.timestamps
    end
  end
end
