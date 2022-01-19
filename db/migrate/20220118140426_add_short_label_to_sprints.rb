class AddShortLabelToSprints < ActiveRecord::Migration[6.1]
  def change
    add_column :sprints, :short_label, :string
  end
end
