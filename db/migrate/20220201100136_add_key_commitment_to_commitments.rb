class AddKeyCommitmentToCommitments < ActiveRecord::Migration[7.0]
  def change
    add_column :commitments, :key_commitment, :boolean, null: false, default: false
  end
end
