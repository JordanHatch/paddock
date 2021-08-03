class AddOrderToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :order, :integer, null: false, default: 0
  end
end
