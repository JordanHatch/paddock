class AddGroupToCommitments < ActiveRecord::Migration[7.0]
  def change
    add_reference :commitments, :group
    add_foreign_key :commitments, :groups, on_delete: :restrict
  end
end
